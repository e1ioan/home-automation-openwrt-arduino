#!/opt/bin/bash

#set -x
exec 2>/mnt/scripts/log/r.err

TMPDIR="/mnt/scripts/tempdata"

delOldFiles()
{
  twohoursago=$(/opt/usr/bin/date -d "-2 hours"  +"%H") #delete all that are this old

  for f in "$TMPDIR"/"$twohoursago"-* ; do
    test -f "$f" || continue
    rm "$f"
  done
}


incData()
{
  if [ -f $1 ];
  then
    echo $(awk '{p=$1} {p++} {print p}' $1) > $1
  else
    echo "1" > $1
  fi
}

oneBlink()
{
  # YYYY-MM-DD-HH
  thisminute=$(date +"%H-%M")
  thishour=$(date +"%Y-%m-%d-%H")
  thisday=$(date +"%Y-%m-%d")
  thismonth=$(date +"%Y-%m")

  incData /mnt/scripts/data/$thishour
  incData /mnt/scripts/data/$thisday
  incData /mnt/scripts/data/$thismonth
  incData /mnt/scripts/tempdata/$thisminute
  
  delOldFiles
}

# set serial port to 9600 baud
# so we can talk to the AVR
# turn off local echo to make TX/RX directions
# completely separate from each other
stty 9600 -echo < /dev/tts/0

# Tell the AVR we're ready to start doing stuff
echo "start" > /dev/tts/0
while true # loop forever
do
  inputline="" # clear input
  # Loop until we get a valid command from arduino
  # the line should be the text file we have to open to get
  # a random message
  until inputline=$(echo $inputline | grep -e "_cmd")
  do
    inputline=$(head -n 1 < /dev/tts/0)
  done
  if [[ "$inputline" == "b_snd_cmd" ]] ; then
    # we received a IR blink from AVR (electricity meter)
    oneBlink
  fi
done


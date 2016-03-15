#!/bin/sh -

# store some paths in handy variables
picsdir=/www/cam2/
pic=SpcaPict.jpg
TNAME=your_twitter_user
TWORD=your_twitter_pass

# set serial port to 9600 baud
# so we can talk to the AVR
# turn off local echo to make TX/RX directions
# completely separate from each other
stty 9600 -echo < /dev/tts/0

# Tell the AVR we're ready to start doing stuff
echo "start" > /dev/tts/0
while true	# loop forever
do
  inputline="" # clear input
  # Loop until we get a valid command from arduino
  # the line should be the text file we have to open to get
  # a random message 
  until inputline=$(echo $inputline | grep -e ".txt")
  do
    inputline=$(head -n 1 < /dev/tts/0)
  done
  # got a valid line - text file name - from arduino
  # example: gus-out.txt
  # now open the file and get a random line from the file
  if [ -f $inputline ]; 
  then
    LINES=`wc -l $inputline | awk '{ print ($inputline + 1) }'`
    RANDSEED=`date '+%S%M%I'`
    LINE=`cat $inputline | awk -v COUNT=$LINES -v SEED=$RANDSEED 'BEGIN { srand(SEED); i=int(rand()*COUNT) } FNR==i { print $0 }'` 

    # got the random line
    # create the twitpic message and send it
    # store everything in vars to make
    # curl opts for multipart form a bit more manageable
    picfile=$picsdir$pic
    cargo="media=@$picfile"
    myname="username=$TNAME"
    pword="password=$TWORD"
    tweet="message=$LINE"
    target="http://twitpic.com/api/uploadAndPost"

    # make sure the file exists and is readable
    while [ ! -r $picfile ]; 
    do
      picfile=$picsdir$pic
    done

    # tell curl to send a multipart form to twitpic
    # save returned XML in a variable
	
    RET=$(curl -s -S -F "$myname" -F "$pword" -F "$cargo" -F "$tweet" $target)
    echo "$RET"
  fi
done



#!/opt/bin/bash

#set -x
exec 2>/mnt/scripts/log/w.err

sprinkler()
{
  echo "325"
}

water_heater()
{
  echo "1"  
}

get_date()
{
  echo $(date +"%H%M%S%m%d%y")
}

cost()
{
  thishour=$(date +"%Y-%m-%d-%H")
  thisday=$(date +"%Y-%m-%d")
  thismonth=$(date +"%Y-%m")
  
  by100=1
  
  if [[ $1 == "h_get_cmd" ]] ; then
    blinksfile=$thishour
  elif  [[ $1 == "d_get_cmd" ]] ; then
    blinksfile=$thisday
  elif [[ $1 == "m_get_cmd" ]] ; then
    blinksfile=$thismonth
    by100=100
  fi
  if [[ -f /mnt/scripts/data/$blinksfile ]]; then
    thecost=$(awk 'FNR==NR{f=$1; next} {s=$1} END {print f*s}' /mnt/scripts/data/$blinksfile /mnt/scripts/const/blinkcost)
  else
    thecost=0
  fi
          
  calc=$(echo "scale=2; $thecost / $by100" | /opt/usr/bin/bc)
  var=$(printf '%0.8f' "$calc")
  echo "${var:0:7}"
}

cstart=s
cend=e
cdollar=1
ccent=0

while true # loop forever
do
  m_cost=$(cost m_get_cmd)
  d_cost=$(cost d_get_cmd)
  h_cost=$(cost h_get_cmd)
  sprk=$(sprinkler)
  wtr=$(water_heater)
  dte=$(get_date)
  sercmd="$cstart$m_cost$cdollar$d_cost$ccent$h_cost$ccent$sprk$wtr$dte$cend"
  echo "$sercmd" > /dev/tts/0
  sleep 5
done

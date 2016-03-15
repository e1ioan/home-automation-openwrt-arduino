#!/bin/sh

#set -x
#exec 2>/tmp/err.log

cost()
{
  thishour=$(date +"%Y-%m-%d-%H")
  thisday=$(date +"%Y-%m-%d")
  yesterday=$(/opt/usr/bin/date -d "-1 days"  +"%Y-%m-%d")
  thismonth=$(date +"%Y-%m")
  
  by100=1
  
  dollar=""
  cent=""
   
  if [[ $1 == "hour" ]] ; then
    blinksfile=$thishour
    cent="c"
  elif  [[ $1 == "day" ]] ; then
    blinksfile=$thisday
    cent="c"
  elif  [[ $1 == "yesterday" ]] ; then
      blinksfile=$yesterday  
  elif [[ $1 == "month" ]] ; then
    blinksfile=$thismonth
    by100=100
    dollar="\$"
  fi
          
  thecost=$(awk 'FNR==NR{tot=$1; next} {print tot*$1}' /mnt/scripts/data/$blinksfile /mnt/scripts/const/blinkcost)
  calc=$(echo "scale=2; $thecost / $by100" | /opt/usr/bin/bc )
  echo "$dollar""$calc""$cent"
}

cost=$(cost $1) 

echo -ne "$dollar""$cost""$cent"

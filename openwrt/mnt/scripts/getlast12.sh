#!/opt/bin/bash

i="0"
rained="0"
while [ $i -lt 12 ]
do
  fname=/mnt/scripts/rain/$(/opt/usr/bin/date -d "-$i hours"  +"%Y-%m-%d-%H")
  if [ -f $fname ]; then
    rained="1" # it rained in last 6 hours
    break
  fi
  i=`expr $i + 1`
done

echo "$rained"


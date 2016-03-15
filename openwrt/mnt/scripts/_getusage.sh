#!/opt/bin/bash

thisminute=$(date +"%H")
lastminute=$(/opt/usr/bin/date -d "-1 hours"  +"%H")

thisday=$(date +"%Y-%m-%d")
yesterday=$(/opt/usr/bin/date -d "-1 days"  +"%Y-%m-%d")
thismonth=$(date +"%Y-%m")
DIR="/mnt/scripts/data"
TMPDIR="/mnt/scripts/tempdata"

if [[ $1 == "minute" ]] ; then
  for f in "$TMPDIR"/"$thisminute"-*
  do
    val=$(cat "$f")
    nam=${f: -2}
    yf="$TMPDIR"/"$lastminute"-"$nam" # last hour's file
    if [[ -f "$yf" ]] ; then
      yval=$(cat "$yf")
      echo "data.addRow([\"$nam\", $yval, $val]);"
    else
      echo "data.addRow([\"$nam\", "0", $val]);"
    fi
  done
elif [[ $1 == "day" ]] ; then
  for f in "$DIR"/"$thisday"-*
  do
    val=$(cat "$f")
    nam=${f: -2}
    yf="$DIR"/"$yesterday"-"$nam" # yesterday's file
    if [[ -f "$yf" ]] ; then
      yval=$(cat "$yf")
      echo "data.addRow([\"$nam\", $yval, $val]);"
    else
      echo "data.addRow([\"$nam\", "0", $val]);"
    fi
  done
elif [[ $1 == "month" ]] ; then
  for f in "$DIR"/"$thismonth"-??
  do
    val=$(cat "$f")
    nam=${f: -2}
    echo "data.addRow([\"$nam\", $val]);"
  done
fi
                  

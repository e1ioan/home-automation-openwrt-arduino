#!/opt/bin/bash
# get the current weather (<weather>value</weather>)
# from the url 
# stored in /mnt/scripts/const/weatherlink

scriptspath=/mnt/scripts
wlink=$scriptspath/const/weatherlink

weatherurl=$(awk 'FNR==NR{url=$1; print url}' $wlink)
weather=$(curl -s $weatherurl | sed -nr 's/[[:blank:]]*<[Ww][Ee][Aa][Tt][Hh][Ee][Rr]>([^<]*)<\/[Ww][Ee][Aa][Tt][Hh][Ee][Rr]>[[:blank:]]*/\1/p')
weather=$(echo $weather | /opt/usr/bin/tr '[:upper:]' '[:lower:]')
if [[ "$weather" = *rain* ]]; then
  rm /mnt/scripts/rain/*
  touch $(echo $scriptspath/rain/$(date +"%Y-%m-%d-%H"))
fi

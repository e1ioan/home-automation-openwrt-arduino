#/bin/sh

OFS=$IFS
IFS=:

awk -F"<|>" '
$2=="weather" && NF > 3{s=$3}
$2=="/weather"{print s}
' file |
while read weather add; do
  echo "$weather"
  done
  
IFS=$OFS

echo "$weather"

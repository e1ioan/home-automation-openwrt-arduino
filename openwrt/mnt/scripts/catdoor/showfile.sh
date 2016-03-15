#!/bin/sh

n=0
emptyline=""
dir="/root/catdoor/"
thefile=$dir$1
echo '<table cellspacing="3">'
while read LINE ; do
  if [ "$LINE" != "$emptyline" ]; then
    echo '<tr>'
    let n=n+1
    echo '<td>'$n'</td><td>'$LINE'</td><td><a href="msg.cgi?fname='$1'&delete='$LINE'">Delete</a></td>'
    echo '</tr>'
  fi
done < $thefile
echo '</table>'

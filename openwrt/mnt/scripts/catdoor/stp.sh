#!/bin/sh -

# store some paths in handy variables
picsdir=/www/cam2/
pic=SpcaPict.jpg
TNAME=twitter_username
TWORD=twitter_password

# now open the file and get a random line from the file
if [ -f $1 ]; 
then
  echo "<html>"
  echo "<body>"
  echo "<font face=verdana size=2>"
  echo "The message was sent..."
  
  LINES=`wc -l $1 | awk '{ print ($1 + 1) }'`
  RANDSEED=`date '+%S%M%I'`
  LINE=`cat $1 | awk -v COUNT=$LINES -v SEED=$RANDSEED 'BEGIN { srand(SEED); i=int(rand()*COUNT) } FNR==i { print $0 }'` 

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
  xmlfile=/tmp/temp.xml
  echo ${RET} > $xmlfile
  tr ' ' '\n' < $xmlfile > $xmlfile.$$
  rm -f $xmlfile
  for tag in mediaurl
  do
    OUT=`grep  $tag $xmlfile.$$ | tr -d '\t' | sed 's/^<.*>\([^<].*\)<.*>$/\1/' `
    # This is what I call the eval_trick, difficult to explain in words.
    eval ${tag}=`echo -ne \""${OUT}"\"`
  done
  rm -f $xmlfile.$$

  URL_ARRAY=`echo ${mediaurl}
  echo $URL_ARRAY
  # delete <mediaurl> in front`
  URL_ARRAY=`echo ${URL_ARRAY#<mediaurl>}`
  # delete </mediaurl> at the end
  URL_ARRAY=`echo ${URL_ARRAY%</mediaurl>}`
  echo "<p><a href="$URL_ARRAY">Here is the link</a></p></font></body></html>"
fi



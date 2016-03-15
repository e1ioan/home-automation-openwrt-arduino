#!/bin/sh

for tag in mediaurl
do
  OUT=`grep  $tag $1 | tr -d '\t' | sed 's/^<.*>\([^<].*\)<.*>$/\1/' `

  # This is what I call the eval_trick, difficult to explain in words.
  eval ${tag}=`echo -ne \""${OUT}"\"`
done

URL_ARRAY=`echo ${mediaurl}
# delete <mediaurl> in front`
URL_ARRAY=`echo ${URL_ARRAY#<mediaurl>}`
# delete </mediaurl> at the end
URL_ARRAY=`echo ${URL_ARRAY%</mediaurl>}`
echo ${URL_ARRAY}



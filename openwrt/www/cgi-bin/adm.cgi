#!/usr/bin/haserl
content-type: text/html

<html>
<head>

<STYLE TYPE="text/css">
<!--
TD{font-family: Verdana; font-size: 10pt;}
--->
</STYLE>

</head>

<body>
<font face=verdana size=2>
<A HREF="javascript:history.back()">Back</A>
<hr> 
<% 
  if [ $FORM_operation = "twitter"  ]; then
    echo '<h0><b>Send twitter message from:</b></h0>'
  else
    echo '<h0><b>Edit following files:</b></h0>'
  fi
%>
<hr>
<p>
<table cellspacing="3">
<% 
  DIR="/root/catdoor"
  SUFFIX="txt"
  for i in "$DIR"/*.$SUFFIX
  do
    echo '<tr><td>'
    filename=""
    filename=$(echo ${i%%.$SUFFIX} | sed 's#^.*/##')
    if [ $FORM_operation = "twitter"  ]; then
      echo '<a href="sendtp.cgi?fname='$filename'.txt">'$filename'</a><br>'
    else
      echo '<a href="msg.cgi?fname='$filename'.txt">'$filename'</a><br>'
    fi
    echo '</td></tr>'
  done
%>
</table>
</p>
</font>
</body>                                                      
</html>

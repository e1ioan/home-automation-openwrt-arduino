#!/usr/bin/haserl --accept-all
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
<p><b>Add another message file:</b>
<form action="<%
   if [ "$FORM_filefield" != "" ]; then
     thefile=${FORM_filefield%%.txt}
     thefile=${thefile%%.TXT}
     touch "/root/catdoor/$thefile.txt"
   fi
   %>" method="POST">
   <%
     # Do some basic validation of FORM_textfield
     # To prevent common web attacks
      FORM_filefield=$( echo "$FORM_filefield" | sed "s/[^A-Za-z0-9 ]//g" )
   %>
   <input type=text name=filefield Value="">
   <input type=submit value=Add>
</form>
</p>
<hr>
<p>
<table cellspacing="3">
<%
  if [ "$FORM_fname" != "" ]; then
    # delete the file if size 0
    find "/root/catdoor/$FORM_fname" -size 0 -exec rm {} \;
  fi
           
  DIR="/root/catdoor"
  SUFFIX="txt"
  for i in "$DIR"/*.$SUFFIX
  do
    echo '<tr>'
    filename=""
    filename=$(echo ${i%%.$SUFFIX} | sed 's#^.*/##')
    echo '<td>'$filename'</td><td><a href="msg.cgi?fname='$filename'.txt">Edit</a></td><td><a href="files.cgi?fname='$filename'.txt">Delete</a></td>'
    echo '</tr>'
  done
%>
</table>
</p>
<p>Only empty files can be deleted.</p>
                                          
</font>
</body>
</html>



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
<p><b>Add another message:</b>
<form action="<%
  if [ "$FORM_textfield" != "" ]; then
    echo $FORM_textfield >>  "/root/catdoor/$FORM_fname"
  fi
%>" method="POST">
<% 
# Do some basic validation of FORM_textfield
# To prevent common web attacks
FORM_textfield=$( echo "$FORM_textfield" | sed "s/[^A-Za-z0-9 ]//g" )
%>
<input type=text name=textfield Value="">
<input type=submit value=Add>
</form>
</p>
<hr>
<%
  if [ "$FORM_delete" != "" ]; then
    echo $FORM_delete
    echo $FORM_fname
    sed "/${FORM_delete}/d" /root/catdoor/$FORM_fname > /root/catdoor/$FORM_fname.$$
    mv /root/catdoor/$FORM_fname.$$ /root/catdoor/$FORM_fname
  fi
  echo "File Name: <b>$FORM_fname</b>"
  echo "<br>"
 /root/catdoor/showfile.sh "$FORM_fname"
%>
</font>
</body>
</html>



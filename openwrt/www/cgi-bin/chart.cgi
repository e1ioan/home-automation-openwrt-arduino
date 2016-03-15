#!/usr/bin/haserl
content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<title>
Electricity Usage
</title>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">google.load('visualization', '1', {packages: ['corechart']});</script>

<script type="text/javascript">
  function drawVisualization() {
     // Create and populate the data table.
     var data = new google.visualization.DataTable();
     data.addColumn('string', 'x');
     data.addColumn('number', 'Last hour'); 
     data.addColumn('number', 'This hour');

<%
 /mnt/scripts/_getusage.sh minute
%>

     // Create and draw the visualization.
     new google.visualization.LineChart(document.getElementById('minute')).
     draw(data, {curveType: "function",width: 1200, height: 400, title: 'Hour usage by minute', vAxis: {maxValue: 10}});
  }
                                                                                                        
                                                                                                        
 google.setOnLoadCallback(drawVisualization);
</script>	

<script type="text/javascript">
  function drawVisualization() {
     // Create and populate the data table.
     var data = new google.visualization.DataTable();
     data.addColumn('string', 'x');
     data.addColumn('number', 'Yesterday'); 
     data.addColumn('number', 'Today');

<%
 /mnt/scripts/_getusage.sh day
%>

     // Create and draw the visualization.
     new google.visualization.LineChart(document.getElementById('day')).
     draw(data, {curveType: "function",width: 1200, height: 400, title: 'Toady  usage (RED), cost:  <% /mnt/scripts/_cost.sh day %>', vAxis: {maxValue: 10}});
  }
                                                                                                        
                                                                                                        
 google.setOnLoadCallback(drawVisualization);
</script>	
<script type="text/javascript">
  function drawVisualization() {
     // Create and populate the data table.
     var data = new google.visualization.DataTable();
     data.addColumn('string', 'x');
     data.addColumn('number', 'Wh usage');

<%
 /mnt/scripts/_getusage.sh month
%>

     // Create and draw the visualization.
     new google.visualization.LineChart(document.getElementById('month')).
     draw(data, {curveType: "function",width: 1200, height: 400, title: 'This month usage, cost: <% /mnt/scripts/_cost.sh month %>', vAxis: {maxValue: 10}});
  }
                                                                                                        
                                                                                                        
 google.setOnLoadCallback(drawVisualization);
</script>	
 </head>
<body style="font-family: Arial;border: 0 none;">
<center>
  <div id="minute"></div>
  <div id="day"></div>
  <div id="month"></div>
</center>
</body>
</html>






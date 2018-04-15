<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<link rel="stylesheet" type="text/css" href="../menu.css"/>
  </head>
  <body style="background-color:#F0F0F0;">	
    <div id="menu-div">
		<h2 align="center">Shift Planner</h2>
		<h2 align="center">Welcome {{rows[0]}}</h2>
			<ul id="menu">
				<li>
					<a href="#">Student ￬</a>
					<ul class="hidden">
						<li><a href="#">Add Student</a></li>
						<li><a href="#">Update Student</a></li>
						<li><a href="#">Delete Student</a></li>
						<li><a href="#">View Student</a></li>
					</ul>
				</li>
				<li>
					<a href="#">Shifts ￬</a>
					<ul class="hidden">
						<li><a href="#">Add Shifts</a></li>
						<li><a href="#">Remove Shifts</a></li>
						<li><a href="#">View Shifts</a></li>
						<li><a href="#">Assign Shifts</a></li>
						<li><a href="#">Cancel Shifts</a></li>
					</ul>
				</li>
				<li><a href="#">Generate Report</a></li>
				<li><a href="#">Logout</a></li>
			</ul>
	</div>
	<div id="contentpane" style="width:80%;margin-left:auto; padding-top:10px;align:center;">
	</div>
  </body>
</html>

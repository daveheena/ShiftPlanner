<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<style type="text/css">
		/*Strip the ul of padding and list styling*/
		ul {
			list-style-type:none;
			margin:0;
			padding:0;
			position: absolute;
		}
		/*Create a horizontal list with spacing*/
		li {
			display:inline-block;
			float: left;
			margin-right: 1px;			
		}
		/*Style for menu links*/
		li a {
			display:block;
			border-radius:5px;
			min-width:140px;
			height: 50px;
			text-align: center;
			line-height: 50px;
			font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			background: #2f3036;
			color: #fff;
			text-decoration: none;
		}
		/*Hover state for top level links*/
		li:hover a {
			background: #2f3036;
		}
		/*Style for dropdown links*/
		li:hover ul a {
			background: #f3f3f3;
			color: #2f3036;
			height: 40px;
			line-height: 40px;
		}
		/*Hover state for dropdown links*/
		li:hover ul a:hover {
			background: #2f3036;
			color: #fff;
		}
		/*Hide dropdown links until they are needed*/
		li ul {
			display: none;
		}
		/*Make dropdown links vertical*/
		li ul li {
			display: block;
			float: none;
		}
		/*Prevent text wrapping*/
		li ul li a {
			width: auto;
			min-width: 100px;
			padding: 0 20px;
		}
		/*Display the dropdown on hover*/
		ul li a:hover + .hidden, .hidden:hover {
			display: block;
		}
		
		/*Responsive Styles*/
		@media screen and (max-width : 760px){
			/*Make dropdown links appear inline*/
			ul {
				position: static;
				display: none;
			}
			/*Create vertical spacing*/
			li {
				margin-bottom: 1px;
			}
			/*Make all menu links full width*/
			ul li, li a {
				width: 100%;
			}
		}
	</style>
  </head>
  <body style="background-color:#F0F0F0;">
	<h2 align="center">Shift Planner</h2>
	<h2 align="center">Welcome {{rows[0]}}</h2>
    <div style="width: 80%; margin-left:auto; margin-right:auto; padding-top:10px;align:center;">		
		<div style="width:80%;margin:auto;">
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
				<li>
					<a href="#">Meal Ticket ￬</a>
					<ul class="hidden">
						<li><a href="#">View Requests</a></li>
						<li><a href="#">Generate Meal Ticket</a></li>
					</ul>
				</li>
				<li>
					<a href="#">Points ￬</a>
					<ul class="hidden">
						<li><a href="#">View Points</a></li>
						<li><a href="#">Deduct Points</a></li>
					</ul>
				</li>
				<li><a href="#">Generate Report</a></li>
				<li><a href="#">View Feedback</a></li>
			</ul>
		</div>
	</div>
	<div id="contentpane" style="width:80%;margin-left:auto; padding-top:10px;align:center;">
	</div>
  </body>
</html>

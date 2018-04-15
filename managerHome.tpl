<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<link rel="stylesheet" type="text/css" href="../menu.css"/>
	<link rel="stylesheet" type="text/css" href="../login.css"/>
	<script type="text/javascript">
		function showDiv(id){
			id.style.display = "block";
		}
		
		function verifyAddShiftsValues(){
			var locationid = document.getElementById("diningLocation").value;
			var startdate = document.getElementById("startDate").value;
			var enddate = document.getElementById("endDate").value;
			
			var starttime = document.getElementById("startTime").value;
			var endtime = document.getElementById("endTime").value;
			
			var time = ["00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]
				
			var totalshifts = document.getElementById("totalShifts").value;
			var today = new Date();
			today = today.getFullYear()+"/"+(today.getMonth()+1)+"/"+today.getDate();
			
			if(locationid==-1 || startdate == "" || enddate == "" || totalshifts == ""){
				document.getElementById("errorLabel").innerHTML = "All the fields are required.";
				return false;
			}
			else if(Date.parse(startdate+"T"+starttime) < Date.parse(today)){
				document.getElementById("errorLabel").innerHTML = "Start Date must occur after today.";
				return false;
			}
			else if(startdate > enddate){
				document.getElementById("errorLabel").innerHTML = "End Date cannot occur before Start Date.";
				return false;
			}
			else if(time.indexOf(starttime) >= time.indexOf(endtime)){
				document.getElementById("errorLabel").innerHTML = "End time cannot occur before Start time.";
				return false;
			}
			else if(int(totalshifts)<0){
				document.getElementById("errorLabel").innerHTML = "Total Shifts must be greater than 0.";
				return false;
			}
			return true;
		}
	</script>
	<style type="text/css">
		input[type="date"]:before {
			content: attr(placeholder) !important;
			color: #aaa;
			margin-right: 0.5em;
		  }
		  input[type="date"]:focus:before,
		  input[type="date"]:valid:before {
			content: "";
		  }
	</style>
  </head>
  <body style="background-color:#F0F0F0;" onload="showDiv({{str(menu[0])}})">
	<div id="main-div">
		<div id="menu-div">
			<h2 align="center">Shift Planner</h2>
			<h2 align="center">Welcome {{values[0]}}</h2>
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
							<li><a href="/addshifts">Add Shifts</a></li>
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
		<div id="contentpane" style="width:100%;margin-left:auto;margin-right:auto;height:60%;bottom:0;z-index: -1; position:absolute;">
			<div id="addshifts" class="form" style="display:none;">				
				<h2 style="padding-top:0;margin-top:0;">Add Shifts</h2>
				<form action="/addshifts" method="POST" class="login-form" onsubmit="return verifyAddShiftsValues();">					
					<select id="diningLocation" name="diningLocation">
						<option value="-1">Select Dining Location</option>
						%for key,value in dininglocation.items():
							<option value="{{key}}">{{value}}</option>
						%end
					</select>
					<input type="date" id="startDate" name="startDate" placeholder="Select Start Date"/>
					<input type="date" id="endDate" name="endDate" placeholder="Select End Date"/>
					%time = ["00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00",					"15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00",					"22:30","23:00","23:30","24:00"]
					<select id="startTime" name="startTime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					<select id="endTime" name="endTime">
						%for hour in time:
							<option value="{{hour}}">{{hour}}</option>
						%end
					</select>
					%days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
					<select id="day" name="day">
						%for day in days:
							<option name="{{day}}">{{day}}</option>
						%end
					</select>
					<input type="number" id="totalShifts" name="totalShifts" placeholder="Total Number of Shifts" min="1">
					<input type="submit" id="addShifts" value="Add Shifts"/>
					<span id="errorLabel" style="color:red"></span>
					%for index,row in enumerate(values):
						%if(index!=0 and row!=None):
							%if(row==1):
								<span id="label{{index}}" style="color:green">Shift details are entered successfully.</span>
							%else:
								<span id="label{{index}}" style="color:red">Error occurred while adding Shift Details.</span>
							%end
						%end
					%end
				</form>
			</div>
		</div>
	<div>
  </body>
</html>

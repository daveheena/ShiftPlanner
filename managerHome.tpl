<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<link rel="stylesheet" type="text/css" href="../menu.css"/>
	<link rel="stylesheet" type="text/css" href="../login.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$('#modalShiftsRetrieveStudents').click(function() {
				var http = new XMLHttpRequest();
				var params = "shiftid="+parseInt(document.getElementById("modalShiftID").innerHTML);
				var url = "/retrieveStudents";
				http.open("POST", url, true);

				//Send the proper header information along with the request
				http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

				http.onreadystatechange = function() {//Call a function when the state changes.
					if(http.readyState == 4 && http.status == 200) {
						alert(http.responsetext);						
					}
				}
				http.send(params);
			});
		});
		// When the user clicks the button, open the modal 
		function shiftsModalDisplay(id,startdate,enddate,starttime,endtime,day,totalshifts) {
			// Get the modal
			var modal = document.getElementById('myModal');

			// Get the <span> element that closes the modal
			var span = document.getElementsByClassName("close")[0];
			modal.style.display = "block";
			
			// When the user clicks on <span> (x), close the modal
			span.onclick = function() {
				modal.style.display = "none";
			}

			// When the user clicks anywhere outside of the modal, close it
			window.onclick = function(event) {
				if (event.target == modal) {
					modal.style.display = "none";
				}
			}
			
			document.getElementById("modalShiftID").innerHTML = id;
			document.getElementById("modalShiftStartDate").innerHTML = startdate;
			document.getElementById("modalShiftEndDate").innerHTML = enddate;
			document.getElementById("modalShiftStartTime").innerHTML = starttime;
			document.getElementById("modalShiftEndTime").innerHTML = endtime;
			document.getElementById("modalShiftDay").innerHTML = day;
			document.getElementById("modalShiftTotalShifts").innerHTML = totalshifts;
		}
		
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
		
		function getShifts(){
			var http = new XMLHttpRequest();
			var dininglocationid = document.getElementById("removeShiftDiningLocation").value;
			var date = document.getElementById("removeShiftDate").value;
			var params = "dininglocationid="+dininglocationid+"&date="+date;
			var url = "/getshifts";
			
			if(dininglocationid==-1 || date == ""){
				document.getElementById("errorLabel1").innerHTML = "All the fields are required.";
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
		  table,td{
			border:1px solid #aaa;
		  }
		  table{
			border-collapse:collapse;
		  }
		  .modal {
			display: none; /* Hidden by default */
			position: fixed; /* Stay in place */
			z-index: 1; /* Sit on top */
			padding-top: 100px; /* Location of the box */
			left: 0;
			top: 0;
			width: 100%; /* Full width */
			height: 100%; /* Full height */
			overflow: auto; /* Enable scroll if needed */
			background-color: rgb(0,0,0); /* Fallback color */
			background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
		}

		/* Modal Content */
		.modal-content {
			background-color: #fefefe;
			margin: auto;
			padding: 20px;
			border: 1px solid #888;
			width: 80%;
		}

		/* The Close Button */
		.close {
			color: #aaaaaa;
			float: right;
			font-size: 28px;
			font-weight: bold;
		}

		.close:hover,
		.close:focus {
			color: #000;
			text-decoration: none;
			cursor: pointer;
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
							<li><a href="/removeshifts">Remove Shifts</a></li>
							<li><a href="#">View Shifts</a></li>
							<li><a href="#">Assign Shifts</a></li>
							<li><a href="#">Cancel Shifts</a></li>
						</ul>
					</li>
					<li><a href="#">Generate Report</a></li>
					<li><a href="/logout">Logout</a></li>
				</ul>
		</div>		
		<div id="contentpane" style="width:100%;margin-left:auto;margin-right:auto;height:60%;bottom:0;z-index: -1; position:absolute;">
			%time = ["00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00",					"15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00",					"22:30","23:00","23:30","24:00"]
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
			<div id="removeshifts" style="display:none;">
				<form action="/getshifts" method="POST" class="login-form" onsubmit="return verifyRemoveShiftsValues();">	
					<div class="form">
						<select id="removeShiftDiningLocation" name="removeShiftDiningLocation">
							<option value="-1">Select Dining Location</option>
							%for key,value in dininglocation.items():
								<option value="{{key}}">{{value}}</option>
							%end
						</select>
						<input type="date" id="removeShiftDate" name="removeShiftDate" placeholder="Select Date"/>					
						<input type="submit" value="Get Shifts" onsubmit="return getShifts()"/>
						<span id="errorLabel1" style="color:red"></span>
					</div>
				</form>
				<table style="width:70%;margin:auto;">
					%for hour in time:
						<tr>
							<td style="width:10%;max-width:10%;text-align:center;" id="{{hour}}">{{hour}}</td>
							%index = time.index(hour)
							%for shift in shifts:
								%index2 = time.index(shift[4])
								%index3 = time.index(shift[5])
								%if( index2 <=index and index3 >= index):
									%if(index2==index):
										<td style="background-color:cyan;border-top:2px solid;border-left:2px solid;border-right:2px solid;border-bottom:0px;max-width:20%;width:20%;cursor:pointer;" 
										onclick="shiftsModalDisplay('{{shift[0]}}','{{shift[2]}}','{{shift[3]}}','{{shift[4]}}','{{shift[5]}}','{{shift[6]}}','{{shift[7]}}')">
											Shift ID: {{shift[0]}}
											<br/>
											Shift Start Date: {{shift[2]}}
											<br/>
											Shift End Date: {{shift[3]}}
										</td>
									%elif(index3==index):
										<td style="background-color:cyan;border-bottom:2px solid;border-left:2px solid;border-right:2px solid;border-top:0px;max-width:20%;width:20%;cursor:pointer;" onclick="shiftsModalDisplay('{{shift[0]}}','{{shift[2]}}','{{shift[3]}}','{{shift[4]}}','{{shift[5]}}','{{shift[6]}}','{{shift[7]}}')"></td>
									%else:
										<td style="background-color:cyan;border-left:2px solid;border-right:2px solid;border-top:0px;border-bottom:0px;max-width:20%;width:20%;cursor:pointer;" onclick="shiftsModalDisplay('{{shift[0]}}','{{shift[2]}}','{{shift[3]}}','{{shift[4]}}','{{shift[5]}}','{{shift[6]}}','{{shift[7]}}')"></td>
									%end
								%else:
									<td></td>
								%end
							%end
						</tr>
					%end
				</table>
			</div>
				<!-- The Modal for remove shifts -->
				<div id="myModal" class="modal">
				  <!-- Modal content -->
				  <div class="modal-content">
					<span id="shiftsModalClose" class="close">&times;</span><br/>
					<b>Shift ID:</b> <label id="modalShiftID"></label><hr>
					<b>Start Date:</b> <label id="modalShiftStartDate"></label><hr>
					<b>End Date:</b> <label id="modalShiftEndDate"></label><hr>
					<b>Start Time:</b> <label id="modalShiftStartTime"></label><hr>
					<b>End Time:</b> <label id="modalShiftEndTime"></label><hr>
					<b>Day:</b> <label id="modalShiftDay"></label><hr>
					<b>Total Shifts:</b> <label id="modalShiftTotalShifts"></label><hr>
					<select id="modalShiftStudentsAvailable">
					</select>
					<select id="modalShiftStudentsAssigned">
					</select>
					<hr>
					<input type="button" id="modalShiftsRetrieveStudents" value="Retrieve Students"/>
					<input type="button" id="modalShiftsRemoveShifts" value="Remove Shifts"/>
					<input type="button" id="modalShiftsUpdateStudents" value="Assign/ Cancel Shifts"/>
					<hr>
					<input type="label" id="modalShiftsLabel"/>
				  </div>
				</div>
		</div>
	<div>
  </body>
</html>

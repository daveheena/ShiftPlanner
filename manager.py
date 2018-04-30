import sqlite3 
import bottle_session
import bottle
from datetime import time, datetime, date
from bottle import route, run, template, request, static_file, get, redirect

managerSession = ""

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

@route('/logout')
def logout():
	session = bottle.request.environ.get('beaker.session')
	session['sp_user']=''
	session['usertype']=''
	return redirect('/')

def getSession():
	session = bottle.request.environ.get('beaker.session')
	if(session!=""):
		return session.get('sp_user')
	else:
		return ""

def managerHome(session):
	checkSession()
	loggedinUser = getSession()
	return template('managerHome',values=[loggedinUser],menu=[""],dininglocation={},shifts=[],students={},studentsassigned={})

def checkSession():
	session = bottle.request.environ.get('beaker.session')
	if(session.get('sp_user') == "" or session.get('sp_user') == None or session.get('usertype')!="MGR"):
		return redirect("/")
	else:
		return ""
	
@route("/addshifts",method="GET")
def addshifts():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT UserID FROM UserInformation WHERE Email = "%s"'%loggedinUser)
	result = cursor.fetchone()
	cursor.execute('SELECT LocationID, Name FROM DiningLocation JOIN UserDiningLocation WHERE LocationID=DiningLocationID AND UserID=?',(result))
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('managerHome',values=[loggedinUser],menu=["addshifts"],dininglocation=diningdetails,shifts=[],students={},studentsassigned={})

@route("/addshifts",method="POST")
def addshifts_todb():
	checkSession()
	loggedinUser = getSession()
	locationid = request.POST.get('diningLocation','').strip()
	startdate = request.POST.get('startDate','').strip()
	enddate = request.POST.get('endDate','').strip()
	starttime = request.POST.get('startTime','').strip()
	endtime = request.POST.get('endTime','').strip()
	day = request.POST.get('day','').strip()
	totalshifts = request.POST.get('totalShifts','').strip()
	
	startyear, startmonth, startday = startdate.split("-")
	endyear, endmonth, endday = enddate.split("-")
		
	time1_str = startdate + " " + starttime
	time2_str = enddate + " " + endtime
	time1 = datetime.strptime(time1_str, "%Y-%m-%d %H:%M")
	time2 = datetime.strptime(time2_str, "%Y-%m-%d %H:%M")
	
	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		connection.execute('INSERT INTO ShiftDetails(LocationID,StartDate,EndDate,StartTime,EndTime,Day,TotalShifts,IsActive) VALUES(?,?,?,?,?,?,?,?)',(int(locationid),date(int(startyear), int(startmonth), int(startday)),
		date(int(endyear), int(endmonth), int(endday)),time1,time2,day,totalshifts,1))
		connection.commit()
	except Exception as err:
		inserted = -1
		
	cursor = connection.cursor()
	cursor.execute('SELECT UserID FROM UserInformation WHERE Email = "%s"'%loggedinUser)
	result = cursor.fetchone()	
	cursor.execute('SELECT LocationID, Name FROM DiningLocation JOIN UserDiningLocation WHERE LocationID=DiningLocationID AND UserID=?',(result))
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('managerHome',values=[loggedinUser,inserted],menu=["addshifts"],dininglocation=diningdetails,shifts=[],students={},studentsassigned={})

@route("/removeshifts",method="GET")
def removeshifts():
	checkSession()
	loggedinUser = getSession()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT UserID FROM UserInformation WHERE Email = "%s"'%loggedinUser)
	result = cursor.fetchone()	
	cursor.execute('SELECT LocationID, Name FROM DiningLocation JOIN UserDiningLocation WHERE LocationID=DiningLocationID AND UserID=?',(result))
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('managerHome',values=[loggedinUser],menu=["removeshifts"],dininglocation=diningdetails,shifts=[],students={},studentsassigned={})
	
@route("/getshifts",method="POST")
def getshifts_fromdb():
	checkSession()
	weekdays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
	loggedinUser = getSession()
	locationid = request.POST.get('removeShiftDiningLocation','').strip()
	date = request.POST.get('removeShiftDate','').strip() + " 00:00:00"
	
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT UserID FROM UserInformation WHERE Email = "%s"'%loggedinUser)
	result = cursor.fetchone()	
	cursor.execute('SELECT LocationID, Name FROM DiningLocation JOIN UserDiningLocation WHERE LocationID=DiningLocationID AND UserID=?',(result))
	result = cursor.fetchall()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	cursor.execute('SELECT ID,LocationID,StartDate,EndDate,strftime("%H:%M",StartTime),strftime("%H:%M",EndTime),Day,TotalShifts FROM ShiftDetails WHERE IsActive=1 AND LocationID=? AND StartDate <= ? AND EndDate >= ? AND day=?',(int(locationid),date,date,weekdays[datetime.strptime(date,"%Y-%m-%d %H:%M:%S").weekday()]))
	result = cursor.fetchall()
	cursor.close()
	print(result)
	return template('managerHome',values=[loggedinUser],menu=["removeshifts"],dininglocation=diningdetails,shifts=result,students={},studentsassigned={})
	
@route("/retrieveStudents",method="POST")
def getstudentsavailability_fromdb():
	checkSession()
	loggedinUser = getSession()
	shiftid = request.POST.get('shiftid','').strip()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM ShiftDetails WHERE ID="%s"'%int(shiftid))
	result = cursor.fetchone()
	cursor.execute('SELECT DISTINCT user.UserID, Name FROM UserInformation user JOIN UserLogin login ON user.Email = login.UserEmail JOIN UserDiningLocation dining ON user.UserID = dining.UserID JOIN ShiftDetails shifts ON dining.DiningLocationID = shifts.LocationID JOIN StudentAvailability avail ON user.UserID = avail.StudentID WHERE dining.DiningLocationID = ? AND login.UserType = "STU" AND avail.StartDate<=? AND avail.EndDate>=? AND avail.StartTime<=? AND avail.EndTime>=? AND avail.Day=? AND avail.IsActive=1 AND user.UserID NOT IN (SELECT StudentID FROM StudentShifts WHERE ShiftID = ?)',(int(result[1]),result[2],result[3],result[4],result[5],result[6],int(result[0])))
	result = cursor.fetchall()
	cursor.execute('SELECT UserID, Name FROM UserInformation user JOIN StudentShifts shifts WHERE user.UserID = shifts.StudentID AND shifts.ShiftID="%s" AND shifts.IsActive=1'%int(shiftid))
	result2 = cursor.fetchall()
	
	studentsassigned = ""
	for row in result2:
		studentsassigned += "<option value='"+str(row[0])+"'>"+str(row[1])+"</option>"
	
	studentsavailable = ""
	for row in result:
		studentsavailable += "<option value='"+str(row[0])+"'>"+str(row[1])+"</option>"
	
	return {'studentsassigned':studentsassigned,'studentsavailable':studentsavailable}
	
@route("/updateStudentsForShift",method="POST")
def updatestudentsforshift_todb():
	checkSession()
	loggedinUser = getSession()
	shiftid = request.POST.get('shiftid','').strip()
	students = request.POST.get('students','').strip().split(",")
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	inserted = 1
	try:
		connection.execute('DELETE FROM StudentShifts WHERE ShiftID="%s"'%int(shiftid))
		connection.commit()
		for studentid in students:
			if(studentid!=''):
				connection.execute('INSERT INTO StudentShifts(ShiftID,StudentID,AddedDate,IsActive) VALUES(?,?,?,?)',(int(shiftid),int(studentid),datetime.now(),1))
		connection.commit()			
	except Exception as err:
		print(err)
		inserted = -1
	return {'status':inserted}
	
@route("/removeShifts",method="POST")
def removeshifts_fromdb():
	checkSession()
	loggedinUser = getSession()
	shiftid = request.POST.get('shiftid','').strip()
	connection = sqlite3.connect('ShiftPlanner.db')
	inserted = 1
	try:
		connection.execute('UPDATE ShiftDetails SET IsActive=0 WHERE ID="%s"'%int(shiftid))
		connection.commit()
	except Exception as err:
		print(err)
		inserted = -1
	return {'status':inserted}
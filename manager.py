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
	return template('managerHome',values=[loggedinUser],menu=[""],dininglocation={},shifts=[])

def checkSession():
	session = bottle.request.environ.get('beaker.session')
	if(session.get('sp_user') == "" or session.get('sp_user') == None):
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
	return template('managerHome',values=[loggedinUser],menu=["addshifts"],dininglocation=diningdetails,shifts=[])

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
	return template('managerHome',values=[loggedinUser,inserted],menu=["addshifts"],dininglocation=diningdetails,shifts=[])

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
	return template('managerHome',values=[loggedinUser],menu=["removeshifts"],dininglocation=diningdetails,shifts=[])
	
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
	return template('managerHome',values=[loggedinUser],menu=["removeshifts"],dininglocation=diningdetails,shifts=result)
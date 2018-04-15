import sqlite3 
import bottle_session
import bottle
from datetime import time, datetime, date
from bottle import route, run, template, request, static_file, get, redirect

managerSession = ""

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

def getSession():
	session = bottle.request.environ.get('beaker.session')
	if(session!=""):
		return session.get('sp_user')
	else:
		return ""

def managerHome(session):
	checkSession()
	loggedinUser = getSession()
	return template('managerHome',values=[loggedinUser],menu=[""],dininglocation={})

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
	cursor.execute('SELECT LocationID, Name FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('managerHome',values=[loggedinUser],menu=["addshifts"],dininglocation=diningdetails)

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
	cursor.execute('SELECT LocationID, Name FROM DiningLocation')
	result = cursor.fetchall()
	cursor.close()
	diningdetails = {}
	for row in result:
		diningdetails[row[0]] = row[1]
	return template('managerHome',values=[loggedinUser,inserted],menu=["addshifts"],dininglocation=diningdetails)
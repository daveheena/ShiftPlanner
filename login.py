import sqlite3 
import manager
import bottle
from bottle import route, run, template, request, debug, static_file, get
from beaker.middleware import SessionMiddleware

session_opts = {
    'session.type': 'file',
    'session.cookie_expires': 300,
    'session.data_dir': './data',
    'session.auto': True
}
app = SessionMiddleware(bottle.app(), session_opts)

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

@route("/")
@route("/login",method="GET")
def login():
	session = bottle.request.environ.get('beaker.session')
	print(session.get('sp_user'))
	if(session.get('sp_user') == "" or session.get('sp_user') == None):
		return template('login',rows=())
	else:
		return manager.managerHome(session)

@route("/login",method="POST")
def userAuthentication():
	email = request.POST.get('loginEmail','').strip()
	password = request.POST.get('loginPassword','').strip()
	connection = sqlite3.connect('ShiftPlanner.db')
	cursor = connection.cursor()
	cursor.execute('SELECT * FROM UserLogin WHERE UserEmail=? AND Password = ?',(str(email),str(password)))
	result = cursor.fetchall()
	cursor.close()
	for row in result:
		if(row[2] == "MGR"):
			return "<p>Login Successful</p>"
		elif(row[2] == "ADM"):
			session = bottle.request.environ.get('beaker.session')
			session['sp_user'] = row[0]
			session.save()
			return manager.managerHome(session)
		elif(row[2] == "STU"):
			session = bottle.request.environ.get('beaker.session')
			session['sp_user'] = row[0]
			session.save()
			return manager.managerHome(session)
		else:
			return "<p>Login Unsuccessful</p>"
	
	return template('login',rows=["User authentication failed."])

bottle.run(app=app, host='localhost',port=8080, reloader=True)
debug(True)
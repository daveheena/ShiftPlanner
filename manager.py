import sqlite3 
import bottle_session
from bottle import route, run, template, request, static_file, get

@get('/<filename:re:.*\.*>')
def server_static(filename):
    return static_file(filename, root='./static/')

def managerHome(session):
	loggedinUser = session.get('sp_user')
	return template('managerHome',rows=[loggedinUser])
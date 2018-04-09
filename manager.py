import sqlite3 
import bottle_session
from bottle import route, run, template, request

def managerHome(session):
	loggedinUser = session.get('sp_user')
	return template('managerHome',rows=[loggedinUser])
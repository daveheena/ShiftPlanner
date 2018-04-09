import sqlite3

connection = sqlite3.connect("ShiftPlanner.db")

connection.execute('CREATE TABLE UserInformation (UserID INTEGER(9) PRIMARY KEY, Name Varchar(30) NOT NULL, Email Varchar(20) NOT NULL, ContactNumber INTEGER(10), CreatedDate DATETIME)')
connection.execute('CREATE TABLE UserLogin (UserEmail Varchar(20), Password Varchar(100) NOT NULL, UserType Varchar(3) NOT NULL, IsActive INTEGER(1), LastLogin DATETIME, FOREIGN KEY (UserEmail) REFERENCES UserInformation(Email))')
connection.execute('INSERT INTO UserInformation VALUES(810917421,"Heena Dave","hdave@kent.edu",3302948223,datetime("now"))')
connection.execute('INSERT INTO UserLogin VALUES("hdave@kent.edu","Admin123","ADM",1,datetime("now"))')
connection.commit()

#database connection information. hostname, username, password, database name.
#change to ask user for username and password before implimentation.
databaseHost = ["localhost", "root", "letmeinnow", "landscape"]

# function to send an SQL statement to the database
def sendStatement(sqlInput):
   #connect to the database
    mydb = mysql.connector.connect (
        host = databaseHost[0],
        user = databaseHost[1],
	    password = databaseHost[2],
	    database = databaseHost[3]
    )
    mycursor = mydb.cursor()

    #run the SQL statement
    mycursor.execute(sqlInput)

# function to send an SQL statement to the database that retrieves information back
def sendRequest(sqlInput):
    #connect to the database
    mydb = mysql.connector.connect (
        host = databaseHost[0],
        user = databaseHost[1],
	    password = databaseHost[2],
	    database = databaseHost[3]
    )
    mycursor = mydb.cursor()

    #run the SQL statement
    mycursor.execute(sqlInput)
    myresult = mycursor.fetchall()

    return myresult
import mysql.connector
import time
from datetime import datetime
import threading                    #used to create multiple threads for event based programming.
import keyboard
import numpy

# modules from same folder
import dataMove
import dataInteract


# --------------------------------------------
# database manipulation functions-------------
# --------------------------------------------


# function to remove incomplete tasks on the database
def clearTasks():
    print("clearing the queue")

    #create SQL statement
    sqlInput = "DELETE from routes WHERE routeComplete = 0"

    #run the SQL statement
    dataInteract.sendStatement(sqlInput)

# function to query the database for current landscape
def mapLandscape():
    print("reticulating splines")

    #create the SQL statement
    #entityID for "nothing" is "1"
    sqlInput = "SELECT xLoc, yLoc, zLoc FROM locations WHERE entityID != 1;"
    
    #run the SQL statement
    myresult = dataInteract.sendRequest(sqlInput)

    return myresult

# function to grab a pattern from the database
def findPattern(patternName):
    print("Pulling information from the database")
    
    #create the SQL statement
    sqlInput = "SELECT pixelLocX, pixelLocY, pixelLocZ FROM patternPixels INNER JOIN patterns ON patternPixels.patternID = patterns.patternID WHERE patterns.patternName = '" + patternName + "';"

    #run the SQL statement
    myresult = dataInteract.sendRequest(sqlInput)

    return myresult

# --------------------------------------------
# multi threading functions ------------------
# these functions all run concurrently -------
# --------------------------------------------

# function to look for user input 'q' to end the program
def userInput():
    print("Start looking for input\n")
    while True:
        if keyboard.is_pressed('q'):
            break

# function to update thread on minute change
def updateTime():
    print("updating the time")
    
    while True:
        #sleep until a new minute changes
        current_time = time.time()
        time_to_sleep = 60 - (current_time % 60)
        time.sleep(time_to_sleep)
        
        #remove all incomplete tasks on the database
        clearTasks()

        #grab time and parse it into digits
        now = datetime.datetime.now()
        currentTime = now.strftime("%H:%M")
        print(currentTime)
        timeArray = numpy.zeros((5, 25)) #25 wide by 5 tall
        #for each digit in currentTime, grab the pattern and splice them together into an array
        digitNum = 0
        for letter in currentTime:
            currentPattern = findPattern(letter)
            for line in currentPattern:
                timeArray[line[(0 + digitNum * 5)], line[1]] = 1
            digitNum = digitNum + 1

        #query database to ping the landscape, build another array
        stuff
        #find differences between what the landscape looks like and the built pattern
        #generate tasks to remove blocks not needed
        #generate tasks to add blocks that are needed
        #upload all tasks to the database

        #if user input task is complete, finish this task after a loop is complete
        if inputThread.is_alive() == False:
            break

# drone thread to look for tasks and complete them
    #if user input task is complete, finish this task after a loop is complete

# --------------------------------------------
# main program start -------------------------
# --------------------------------------------

#create thread variable functions attached to the threading functions
inputThread = threading.Thread(target=userInput, name='inputThread')
updateTimeThread = threading.Thread(target=updateTime, name='updateTimeThread')

#start the threads
print("Looking for user input thread starting.\n")
inputThread.start()
print("starting the updateTime thread")
updateTimeThread.start()

#join the threads back into the main program when complete
inputThread.join()
updateTimeThread.join()

print("all tasks complete, shutting down.\n")

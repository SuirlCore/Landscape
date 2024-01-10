import time
from datetime import datetime
import threading                    #used to create multiple threads for event based programming.
import keyboard
import numpy
import math

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
    sqlInput = "DELETE from routes WHERE routeComplete = 0;"

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

# function to query the database for the coordinates of the corners for the field
def mapSize():
    print("pinging database for cornerstones.")

    #create the SQL statement
    sqlInput = "SELECT (xLoc, yLoc, zLoc) FROM locations WHERE entityID = 5;"

    #run the SQL statement
    myresult = dataInteract.sendRequest(sqlInput)

    return myresult

# function to query what is currently in the field
def mapField(xMin, xMax, yMin, yMax):
    print("mapping the field.")

    #create the SQL statement
    #entityID for "pixel" is "4"
    sqlInput = "SELECT xLoc, yLoc, zLoc FROM locations WHERE (entityID = 4) AND (xLoc BETWEEN " + xMin + " AND" + xMax + ") AND (yLoc BETWEEN " + yMin + " AND " + yMax + ");"

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

#function to send a list of coordinates to remove pixels from the field
def removePixel(xLoc, yLoc, zLoc):
    print("allocating drones")

    #create SQL statement to run a SQL stored procedure. Finds the entityID at a specific location
    #and adds that ID to the routes to be removed
    sqlInput = "removePixel(" + xLoc + ", " + yLoc + ", " + zLoc + ");"

    #run the SQL statement
    dataInteract.sendStatement(sqlInput)

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
        timeArray = numpy.zeros((25, 5)) #25 wide by 5 tall

        #for each digit in currentTime, grab the pattern and splice them together into an array
        digitNum = 0
        for letter in currentTime:
            currentPattern = findPattern(letter)
            for line in currentPattern:
                timeArray[line[(0 + digitNum * 5)], line[1]] = 1
            digitNum = digitNum + 1

        #query database to ping the landscape size, build another array
        cornerstones = mapSize()

        #find the min and max coordinates for x and y on the field
        xMin = 0
        xMax = 0
        yMin = 0
        yMax = 0
        for stone in cornerstones:
            if (stone[0] < xMin):
                xMin = stone[0]
            if (stone[0] > xMax):
                xMax = stone[0]
            if (stone[1] < yMin):
                yMin = stone[1]
            if (stone[1] > yMax):
                yMax = stone[1]

        #find the size of the current landscape, and increase the pattern size to match the landscape
        xFieldSize = xMax - xMin
        yFieldSize = yMax - yMin
        
        xDif = xMax - 25
        yDif = yMax - 5
        timeOnField = numpy.zeros((xFieldSize, yFieldSize))

        xLoc = 0
        yLoc = 0
        for xVal in timeArray:
            print(xVal)
            for yVal in xVal:
                if yVal == 1:
                    timeOnField[(xLoc + (xDif // 2)), (yLoc + (yDif // 2))] = 1
                    yLoc = yLoc + 1
            xLoc = xLoc + 1

        #find differences between what the landscape looks like and the built pattern
        # timeOnField is an x, y array map of 0's and 1's coresponding to pixels where 1's are.
        # currentField is a list of x, y, z coordinates where pixels exist on the field
        currentField = mapField(xMin, xMax, yMin, yMax)

        for record in currentField:
            if timeOnField[record[0], record[1]] == 0:
                 removePixel(record[0], record[1], record[2])

        #generate tasks to add blocks that are needed

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

import datetime
import threading                    #used to create multiple threads for event based programming.
import keyboard

# modules from same folder
import dataMove
import dataInteract

#log into the database


# --------------------------------------------
# multi threading functions ------------------
# these functions all run concurrently -------
# --------------------------------------------

#doing things task
def droneTask():
    print("Drone logged in and starting")
    #loop
        #check for available tasks
        #grab a task
        #double check that a task was grabbed by this drone and another didnt kipe it
            #if task claimed by another, claim one again
        #do task
        #check if the log out flag task is finished

#look for log out flag
def userInput():
    #if this task ends then the doing things task ends
    print("Start looking for input\n")
    while True:
        if keyboard.is_pressed('q'):
            break
        #!!!! or another flag?

# --------------------------------------------
# main program start -------------------------
# --------------------------------------------

#create thread variable functions attached to the threading functions
inputThread = threading.Thread(target=userInput, name='inputThread')
droneTaskThread = threading.Thread(target=droneTask, name='droneTaskThread')


#start the threads
print("Looking for user input thread starting.\n")
inputThread.start()
print("starting the droneTask thread")
droneTaskThread.start()


#join the threads back into the main program when complete
inputThread.join()
droneTaskThread.join()

#safely log out of the system
    #any database records in progress that need fixed?

print("all tasks complete, shutting down.\n")

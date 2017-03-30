import math
import socket
import pickle
import RPi.GPIO as GPIO
from time import sleep
import spidev
from decimal import *
import numpy as np
import struct

TCP_IP = '192.168.1.4'
TCP_PORT = 5005
BUFFER_SIZE = 1024

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))


MyARM_ResetPin = 19 # Pin 4 of connector = BCM19 = GPIO[1]

MySPI_FPGA = spidev.SpiDev()
MySPI_FPGA.open(0,0)
MySPI_FPGA.max_speed_hz = 500000

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(MyARM_ResetPin, GPIO.OUT)

GPIO.output(MyARM_ResetPin, GPIO.HIGH)
sleep(0.1)
GPIO.output(MyARM_ResetPin, GPIO.LOW)
sleep(0.1)

def floatToBinary32(value):
    val = struct.pack('!f', value)
    return val

def intToFloat(value):
    val= struct.unpack('!f',value)
    return val

isActivePlayer = True

done = False

while not done:
	ToSPI = [0x01, 0x00, 0x00, 0x00, 0x00]	
	XdirSend = MySPI_FPGA.xfer2(ToSPI)
	#Xdir_Send= intToFloat(bytes(XdirSend[1:]))

	ToSPI = [0x02, 0x00, 0x00, 0x00, 0x00]
	YdirSend = MySPI_FPGA.xfer2(ToSPI)
	#Ydir_Send= intToFloat(bytes(YdirSend[1:])) 
	
	
	if isActivePlayer:
           # Send to the other player
           print("Send data")
           message = pickle.dumps([XdirSend, YdirSend])
           s.send(message)
           isActivePlayer = False
	
        elif not isActivePlayer:
           # Wait data from the other player
           print("Wait data")
           data = s.recv(BUFFER_SIZE)
           if not data: break
           a = pickle.loads(data)
           print("received data:", a)
           ToSPI = [0x84, 0x00, 0x00, 0x00, 0x01]
	   isReceived = MySPI_FPGA.xfer2(ToSPI)	   
           dir1= a[0]#floatToBinary32(a[0])
           dir2= a[1]#floatToBinary32(a[1])
           ToSPI = [0x87, 0x00, 0x00, 0x00, dir1]	
	   Xdir = MySPI_FPGA.xfer2(ToSPI)
	   ToSPI = [0x88, 0x00, 0x00, 0x00, dir2]
	   Ydir = MySPI_FPGA.xfer2(ToSPI)
           isActivePlayer = True


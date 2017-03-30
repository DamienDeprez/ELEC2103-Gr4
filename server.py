import math
import socket
import pickle
import RPi.GPIO as GPIO
from time import sleep
import spidev
from decimal import *
import numpy as np
import struct


#************************************************
#*            Function Definition               *
#************************************************
#------------------------------------------------
# Convert a flot to a 32 binary number
#------------------------------------------------
def float2bin32(value):
	return struct.unpack('I', struct.pack('f', value))[0]


#------------------------------------------------
# Convert a 32 binary number to a float
#------------------------------------------------
def bin32tofloat(value):
	return struct.unpack('f', struct.pack('I', value))[0]


#------------------------------------------------
# Create the vector to send through the SPI
#------------------------------------------------
def data2SPI(address, value, operation):
	data = [0x00, 0x00, 0x00, 0x00, 0x00]
	if operation == 1 :  # write
		data[0] = 0x80 + address
	else:
		data[0] = address
	data[4] = value & 0xFF
	data[3] = (value >> 8) & 0xFF
	data[2] = (value >> 16) & 0xFF
	data[1] = (value >> 24) & 0xFF

	return data


#------------------------------------------------
# Recover the data contain in a SPI vector
#------------------------------------------------
def SPI2number(SPI_data):
	return (SPI_data[1] << 24) + (SPI_data[2] << 16) + (SPI_data[3] << 8) + SPI_data[4]



TCP_IP = '192.168.1.5'
TCP_PORT = 5005
BUFFER_SIZE = 1024

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)
conn, addr = s.accept()

print("Connection address : ",addr)


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

isActivePlayer = False

done = False

while not done:
	isDataValide = SPI2number(MySPI_FPGA.xfer2(data2SPI(3, 0, 0))) # is Data are available

	if isActivePlayer and isDataValide: # si je suis le joueur actif et j'ai des données valides
		XdirSend = SPI2number(MySPI_FPGA.xfer2(data2SPI(1, 0, 0)))
		YdirSend = SPI2number(MySPI_FPGA.xfer2(data2SPI(2, 0, 0)))
		print("Send data")
		message = pickle.dumps([XdirSend, YdirSend])
		conn.send(message)
		isActivePlayer = False
		MySPI_FPGA.xfer2(data2SPI(3, 0, 1)) # consume data
	
	elif not isActivePlayer:
		# Wait data from the other player
		print("Wait data")
		data = conn.recv(BUFFER_SIZE)
		if not data: break
		a = pickle.loads(data)
		print("received data:", a)
		MySPI_FPGA.xfer2(data2SPI(7, a[0], 1))
		MySPI_FPGA.xfer2(data2SPI(8, a[1], 1))
		MySPI_FPGA.xfer2(data2SPI(4, 1, 1))
		isActivePlayer = True


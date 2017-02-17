import socket
import time
import select
import sys


def waitFunction(a):
	time.sleep(a)

IP_CLIENT = "130.104.207.216"
PORT_CLIENT_TCP = 5005
PORT_CLIENT_UDP = 5006

IP_SERVER = "130.104.207.208"
PORT_SERVER_TCP=5005
PORT_SERVER_UDP=5006


protocol_name = sys.argv[1]
print "Picture transfer protocol: ", protocol_name
nblockingWaitTime=0.01

doWait=True
#work well
waitTime=0.01


print "IP CLIENT:", IP_CLIENT
print "Ports CLIENT TCP:", PORT_CLIENT_TCP
print "Ports CLIENT UDP:", PORT_CLIENT_UDP

print "IP SERVER:", IP_SERVER
print "Ports SERVER TCP:", PORT_SERVER_TCP
print "Ports SERVER UDP:", PORT_SERVER_UDP

UDPsock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
UDPsock.bind((IP_CLIENT,PORT_CLIENT_UDP))

TCPsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

imagePath="Tools_1524x1200_8b.ppm"
file = open(imagePath, 'wb')

TCPsock.connect((IP_SERVER,PORT_SERVER_TCP))
sent = TCPsock.send(imagePath)
if sent ==0:
	raise RunTimeError("socket connection broken")

imageSizeStr = TCPsock.recv(128) 
imageSize = int(imageSizeStr)
packetSizeStr = TCPsock.recv(128) 
packetSize = int(packetSizeStr)

print "ImageSize:", imageSize, " packetSize:", packetSize

pointer=0
data=bytearray()

chunks=[]
bytes_recd=0
t = time.time()
#TCP
if protocol_name=="TCP":
	while bytes_recd<imageSize:
		chunk = TCPsock.recv(min(imageSize,imageSize-bytes_recd))
		if chunk == b'':
			raise RuntimeError("socket connection broken")
		chunks.append(chunk)
		bytes_recd = bytes_recd + len(chunk)
		if doWait==True:
			waitFunction(waitTime)	
	data = b''.join(chunks)

#UDP blocking
elif protocol_name=="UDP_blocking":
	while bytes_recd<imageSize:
		data[bytes_recd:min(bytes_recd+packetSize,imageSize)] = UDPsock.recv(min(packetSize, imageSize-bytes_recd))
		bytes_recd = bytes_recd + packetSize
		if doWait==True:
			waitFunction(waitTime)	


#UDP non blocking
elif protocol_name=="UDP_nblocking":
	while bytes_recd<imageSize:
		ready=select.select([UDPsock], [], [], nblockingWaitTime)	
		if ready[0]:
			data[bytes_recd:min(bytes_recd+packetSize,imageSize)] = UDPsock.recv(min(packetSize, imageSize-bytes_recd))
			bytes_recd = bytes_recd + packetSize
		else:
			data[bytes_recd:min(bytes_recd+packetSize,imageSize)] = bytearray(min(packetSize,imageSize-bytes_recd))
			bytes_recd = bytes_recd + min(packetSize,imageSize-bytes_recd)
		if doWait==True:
			waitFunction(waitTime)		
	#do blanking if all the packet have not been received to be able to vizualize the ppm
	if len(data) < imageSize:
		data[len(data):imageSize] = bytearray(imageSize-len(data)) 
else:
	print "Unknown picture transfer protocol"

elapsed = time.time() - t
print "elapsed time:", elapsed
file.write(data)
print "Size received:", len(data)

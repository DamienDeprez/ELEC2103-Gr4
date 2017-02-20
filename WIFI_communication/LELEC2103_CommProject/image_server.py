import socket
import time
import sys

IP_CLIENT = "130.104.207.216"
PORT_CLIENT_TCP = 5005
PORT_CLIENT_UDP = 5006

IP_SERVER = "130.104.207.208"
PORT_SERVER_TCP=5005
PORT_SERVER_UDP=5006

protocol_name = sys.argv[1]
print "Picture transfer protocol: ", protocol_name


print "IP CLIENT:", IP_CLIENT
print "Ports CLIENT TCP:", PORT_CLIENT_TCP
print "Ports CLIENT UDP:", PORT_CLIENT_UDP

print "IP SERVER:", IP_SERVER
print "Ports SERVER TCP:", PORT_SERVER_TCP
print "Ports SERVER UDP:", PORT_SERVER_UDP

UDPsock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
UDPsock.bind((IP_SERVER,PORT_SERVER_UDP))
packetSize=65507


TCPsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
TCPsock.bind((IP_SERVER,PORT_SERVER_TCP))
TCPsock.listen(1)


while True:
	conn, addr = TCPsock.accept()
	print "Connection address:", addr
	imagePath = conn.recv(128)
	if not imagePath: break
	file = open(imagePath, 'rb')
	content = file.read()
	sent = conn.send(str(len(content)).zfill(128))
	if sent ==0:
			raise RunTimeError("socket connection broken")
	sent = conn.send(str(packetSize).zfill(128))
	if sent ==0:
			raise RunTimeError("socket connection broken")
	totalsent=0
	#TCP	
	if protocol_name=="TCP":
		while totalsent<len(content):
			sent =	conn.send(content[totalsent:])
			if sent ==0:
				raise RunTimeError("socket connection broken")
			totalsent=totalsent+sent
	#UDP
	elif protocol_name=="UDP_blocking" or protocol_name=="UDP_nblocking":
		while totalsent<len(content):
			UDPsock.sendto(content[totalsent:min(totalsent+packetSize,len(content))], (IP_CLIENT, PORT_CLIENT_UDP))
			totalsent=totalsent+packetSize
	else:
		print "Unknown picture transfer protocol"

conn.close()

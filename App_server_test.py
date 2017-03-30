import Display
import Physics
import math
import socket
import pickle

TCP_IP = '192.168.36.151'
TCP_PORT = 5005
BUFFER_SIZE = 1024

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.bind((TCP_IP, TCP_PORT))
s.listen(1)

con, addr = s.accept()
print('Connection address:', addr)

while not done:
    if isActivePlayer:
        # Send to the other player
        message = pickle.dumps([3.0, 4.0])
        con.send(message)
        isActivePlayer = False
        print("Send data")
        shoot = False
    elif not isActivePlayer:
        # Wait data from the other player
        print("Wait data")
        data = con.recv(BUFFER_SIZE)
        if not data: break
        a = pickle.loads(data)
        print ("received data:", a)

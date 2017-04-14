import socket
import pickle

TCP_IP = '192.168.1.4'
TCP_PORT = 5005
BUFFER_SIZE = 1024
MESSAGE = "Hello, World from client 1!"
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))
s.send(pickle.dumps(MESSAGE))
data = pickle.loads(s.recv(BUFFER_SIZE))
s.close()
print("received data:", data)


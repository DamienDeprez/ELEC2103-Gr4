import pygame
import DisplayServer
import Physics
import math
import socket
import pickle

TCP_IP = '130.104.153.105'
TCP_PORT = 5005
BUFFER_SIZE = 1024

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

pygame.init()
WINDOW_SIZE = [1200,720]
screen = pygame.display.set_mode(WINDOW_SIZE)
pygame.display.set_caption("Billard - Server")
x1 = 0
y1 = 0
x2 = 0
y2 = 0

is_start_point = False
LEFT = 1
RIGHT = 3

BORDER_X = 16
BORDER_Y = 10
BORDER = 40

SIZE = 13

MAX_X = 800
MAX_Y = 480

isActivePlayer = False

done = False
shoot = False


x_ball_1 = 250
y_ball_1 = 250

print("draw")

DisplayServer.draw_background(screen)
DisplayServer.draw_ball(screen, (255, 255, 255), int(x_ball_1), int(y_ball_1))
pygame.display.update()

clock = pygame.time.Clock()

s.bind((TCP_IP, TCP_PORT))
s.listen(1)

con, addr = s.accept()
print('Connection address:', addr)

while not done:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
        if isActivePlayer:
            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == LEFT:
                    if not is_start_point and not shoot:
                        is_start_point = True
                        (x1, y1) = pygame.mouse.get_pos()
            elif event.type == pygame.MOUSEBUTTONUP:
                if event.button == LEFT:
                    (x2, y2) = pygame.mouse.get_pos()
                    is_start_point = False
                    shoot = True
            elif event.type == pygame.MOUSEMOTION and is_start_point:
                (x, y) = pygame.mouse.get_pos()
                x_dir = (x - x1)
                y_dir = (y - y1)
                length = max(math.sqrt(x_dir * x_dir + y_dir * y_dir), 1)
                vector = [x_dir / length, y_dir / length]
                length = min(length, 510)
                DisplayServer.draw_background(screen)
                DisplayServer.draw_ball(screen, (255, 255, 255), int(x_ball_1), int(y_ball_1))
                #DisplayServer.draw_line(screen, (0, int(length/2.0), int(length/2.0)), int(x_ball_1), int(y_ball_1), int(x_ball_1)+vector[0]*200, int(y_ball_1)+vector[1]*200, 4)
                DisplayServer.draw_line(screen, (128, 128, 128), x1, y1, x, y, 2)
    if isActivePlayer and shoot:
        # Send to the other player
        message = pickle.dumps([x2 - x1, y2 - y1])
        con.send(message)
        isActivePlayer = False
        print("Send data")
        x_dir = (x2 - x1)
        y_dir = (y2 - y1)
        (x_ball_1, y_ball_1) = Physics.shoot(screen, x_dir, y_dir, x_ball_1, y_ball_1)
        clock.tick(60)
        shoot = False
    elif not isActivePlayer:
        # Wait data from the other player
        print("Wait data")
        data = con.recv(BUFFER_SIZE)
        if not data: break
        a = pickle.loads(data)
        print ("received data:", a)
        (x_ball_1, y_ball_1) = Physics.shoot(screen, a[0], a[1], x_ball_1, y_ball_1)
        isActivePlayer = True
    pygame.display.update()
pygame.quit()

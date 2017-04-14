import pygame
import Display
import Physics
import math
import time
import pickle
import select
import socket
import Constant


x1 = 0
y1 = 0
x2 = 0
y2 = 0

is_start_point = False
LEFT = 1
RIGHT = 3

BORDER_X = 46
BORDER_Y = 23
BORDER = 40

SIZE = 13

MAX_X = 800
MAX_Y = 480

isActivePlayer = False

done = False
shoot = False



def block_data(socket):
    data = pickle.loads(socket.recv(Constant.BUFFER_SIZE))
    print("received data from server blocking mode :", data)
    if data == -1:
        socket.close()
        exit(0)
    else:
        return data


def select_data(socket):
    r,w,e = select.select([socket], [], [], 0.1)
    for a in r:
        data = pickle.loads(socket.recv(Constant.BUFFER_SIZE))
        print("received data from server non blocking mode :", data)
        if data == -1:
            socket.close()
            exit(0)
        else:
            return data


def player_order(data):
    print("first player = ", data[1])
    if data[1] == Constant.ID_1 and data[0] == Constant.SELECT_FIRST_PLAYER:
        isActivePlayer = True
        ready = True
    elif data[1] != Constant.ID_1 and data[0] == Constant.SELECT_FIRST_PLAYER:
        isActivePlayer = False
        ready = True
    else:
        ready = False
        isActivePlayer = False
    return [isActivePlayer, ready]


pygame.init()
WINDOW_SIZE = [1026, 512]
WINDOW_SIZE_SERVER = [1200, 720]
screen = pygame.display.set_mode(WINDOW_SIZE)
pygame.display.set_caption("Billard - Client 1")

ball = [[266, 263],  # blanche   0
        [626, 263],  # noir      1
        [603, 249],  # 1         2
        [603, 277],  # 2         3
        [626, 290],  # 1         4
        [626, 236],  # 2         5
        [649, 222],  # 1         6
        [649, 249],  # 2         7
        [649, 277],  # 1         8
        [649, 304]]  # 2         9

Display.draw_background(screen)
Display.draw_ball(screen, (255, 255, 255), ball[0])
Display.draw_ball(screen, (16, 16, 16), ball[1])
Display.draw_ball(screen, (255, 255, 0), ball[2])
Display.draw_ball(screen, (255, 0, 0), ball[3])
Display.draw_ball(screen, (255, 255, 0), ball[4])
Display.draw_ball(screen, (255, 0, 0), ball[5])
Display.draw_ball(screen, (255, 255, 0), ball[6])
Display.draw_ball(screen, (255, 0, 0), ball[7])
Display.draw_ball(screen, (255, 255, 0), ball[8])
Display.draw_ball(screen, (255, 0, 0), ball[9])

#Display.draw_score(screen, game_data[1][0], game_data[1][1])
#Display.draw_active_player(screen, game_data[0])
score = [0, 0]
number_of_ball = 10

clock = pygame.time.Clock()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((Constant.TCP_IP, Constant.TCP_PORT))

while not done:
    block_data(s)
    print("start new game")

    ready = False
    ready_send = False

    # Wait for the other player is ready or the player touch the screen
    while not ready:
        data = select_data(s)
        if data:
            isActivePlayer, ready = player_order(data)
        for event in pygame.event.get():
            if event.type == pygame.MOUSEBUTTONDOWN and not ready_send:
                print("player detected")
                ready_send = True
                s.send(pickle.dumps([Constant.PLAYER_READY, Constant.ID_1]))
                time.sleep(0.1)
                break

    # Ready to start the game
    print("ready to start the game")
    s.send(pickle.dumps([Constant.ALL_PLAYER_READY, Constant.ID_1]))

    # Wait for all players are ready
    print("wait for all player")
    while block_data(s)[0] != Constant.ALL_PLAYER_READY: time.sleep(0.1)
    print("start the game - ", isActivePlayer)
    game_running = True

    while game_running:
        if isActivePlayer:
            shoot = False
            while not shoot:
                for event in pygame.event.get():
                    if event.type == pygame.MOUSEBUTTONDOWN and event.button == LEFT and not is_start_point and not shoot:
                        is_start_point = True
                        (x1, y1) = pygame.mouse.get_pos()
                    elif event.type == pygame.MOUSEBUTTONUP and event.button == LEFT:
                        is_start_point = False
                        (x2, y2) = pygame.mouse.get_pos()
                        shoot = True
                    elif event.type == pygame.MOUSEMOTION and is_start_point:
                        (x, y) = pygame.mouse.get_pos()
                        x_dir = (x - x1)
                        y_dir = (y - y1)
                        length = max(math.sqrt(x_dir * x_dir + y_dir * y_dir), 1)
                        vector = [x_dir / length, y_dir / length]
                        length = min(length, 510)
                        Display.draw_background(screen)
                        Display.draw_ball(screen, (255, 255, 255), ball[0])
                        Display.draw_ball(screen, (16, 16, 16), ball[1])
                        Display.draw_ball(screen, (255, 255, 0), ball[2])
                        Display.draw_ball(screen, (255, 0, 0), ball[3])
                        Display.draw_ball(screen, (255, 255, 0), ball[4])
                        Display.draw_ball(screen, (255, 0, 0), ball[5])
                        Display.draw_ball(screen, (255, 255, 0), ball[6])
                        Display.draw_ball(screen, (255, 0, 0), ball[7])
                        Display.draw_ball(screen, (255, 255, 0), ball[8])
                        Display.draw_ball(screen, (255, 0, 0), ball[9])
                        Display.draw_help(screen, (0, int(length / 2.0), int(length / 2.0)), ball[0], vector, 300)
                        Display.draw_score(screen, score[0], score[1])
                        Display.draw_active_player(screen, Constant.ID_1)
                        Display.draw_line(screen, (128, 128, 128), x1, y1, x, y, 2)
                pygame.display.update()
                clock.tick(60)
            dir = [x2-x1, y2-y1]
            s.send(pickle.dumps([Constant.GAME_DATA, Constant.ID_1, dir, score, number_of_ball]))
            Physics.shoot(screen, dir[0], dir[1], ball, [Constant.ID_1, score, number_of_ball])
            isActivePlayer = False

            Display.draw_background(screen)
            Display.draw_ball(screen, (255, 255, 255), ball[0])
            Display.draw_ball(screen, (16, 16, 16), ball[1])
            Display.draw_ball(screen, (255, 255, 0), ball[2])
            Display.draw_ball(screen, (255, 0, 0), ball[3])
            Display.draw_ball(screen, (255, 255, 0), ball[4])
            Display.draw_ball(screen, (255, 0, 0), ball[5])
            Display.draw_ball(screen, (255, 255, 0), ball[6])
            Display.draw_ball(screen, (255, 0, 0), ball[7])
            Display.draw_ball(screen, (255, 255, 0), ball[8])
            Display.draw_ball(screen, (255, 0, 0), ball[9])

            Display.draw_score(screen, score[0], score[1])
            Display.draw_active_player(screen, Constant.ID_2)

            pygame.display.update()

            if number_of_ball == 1:
                game_running = False

        else:
            data = block_data(s)
            score = data[3]
            Physics.shoot(screen, data[2][0], data[2][1], ball, [Constant.ID_2, score, data[4]])
            isActivePlayer = True

            Display.draw_background(screen)
            Display.draw_ball(screen, (255, 255, 255), ball[0])
            Display.draw_ball(screen, (16, 16, 16), ball[1])
            Display.draw_ball(screen, (255, 255, 0), ball[2])
            Display.draw_ball(screen, (255, 0, 0), ball[3])
            Display.draw_ball(screen, (255, 255, 0), ball[4])
            Display.draw_ball(screen, (255, 0, 0), ball[5])
            Display.draw_ball(screen, (255, 255, 0), ball[6])
            Display.draw_ball(screen, (255, 0, 0), ball[7])
            Display.draw_ball(screen, (255, 255, 0), ball[8])
            Display.draw_ball(screen, (255, 0, 0), ball[9])

            Display.draw_score(screen, score[0], score[1])
            Display.draw_active_player(screen, Constant.ID_1)

            pygame.display.update()

            if number_of_ball == 1:
                game_running = False





pygame.quit()

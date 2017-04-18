import pygame
import DisplayServer as Display
import socket
import pickle
import select
import Physics_Server as Physics
import time
import Constant

TCP_IP = '127.0.0.1'
TCP_PORT = 5005
BUFFER_SIZE = 1024

pygame.init()
WINDOW_SIZE_SERVER = [1200, 720]
screen = pygame.display.set_mode(WINDOW_SIZE_SERVER)
pygame.display.set_caption("Billard")

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

pygame.display.update()


clock = pygame.time.Clock()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)
client1, addr1 = s.accept()
print('Client 1 :', addr1)
client2, addr2 = s.accept()
print('Client 2 :', addr2)
try:
    while True:
        client1.send(pickle.dumps(1))
        client2.send(pickle.dumps(1))

        firstPlayer = 0
        wait_for_ready = [True, True]
        wait_for_game_start = [True, True]
        is_playing = False

        while wait_for_ready[0] or wait_for_ready[1]:
            read, write, execute = select.select([client1, client2], [], [], 0.1)
            for client in read:
                data = client.recv(BUFFER_SIZE)
                data = pickle.loads(data)
                print("received data : ",data)
                if firstPlayer == 0:
                    firstPlayer = data[1]
                if data[1] == Constant.ID_1 and wait_for_ready[0] and data[0] == Constant.PLAYER_READY:
                    wait_for_ready[0] = False
                if data[1] == Constant.ID_2 and wait_for_ready[1] and data[0] == Constant.PLAYER_READY:
                    wait_for_ready[1] = False

        # send who is the first player
        client1.send(pickle.dumps([Constant.SELECT_FIRST_PLAYER, firstPlayer]))
        client2.send(pickle.dumps([Constant.SELECT_FIRST_PLAYER, firstPlayer]))

        # Wait for the two players are ready
        while wait_for_game_start[0] or wait_for_game_start[1]:
            r, w, e = select.select([client1, client2], [], [], 0.1)
            for client in r:
                data = pickle.loads(client.recv(BUFFER_SIZE))
                # print("received data from client wait game start:", data)
                if data[1] == Constant.ID_1 and wait_for_game_start[0] and data[0] == Constant.ALL_PLAYER_READY:
                    wait_for_game_start[0] = False
                if data[1] == Constant.ID_2 and wait_for_game_start[1] and data[0] == Constant.ALL_PLAYER_READY:
                    wait_for_game_start[1] = False
            time.sleep(0.1)

        # print("The game can start")

        # Send the start signal to the player
        client1.send(pickle.dumps([Constant.ALL_PLAYER_READY, 0]))
        client2.send(pickle.dumps([Constant.ALL_PLAYER_READY, 0]))

        game_running = True
        currentPlayer = firstPlayer

        Display.draw_score(screen, 0, 0)
        Display.draw_active_player(screen, firstPlayer)
        pygame.display.update()

        # Exchange information between the two player
        while game_running:
            if currentPlayer == Constant.ID_1:
                data = client1.recv(BUFFER_SIZE) # Frame [Type, ID, [x , y], [score 1 , score 2], number_of_ball]
                client2.send(data)
                data = pickle.loads(data)
                print("game data : ",data)
                game_data = [data[1], data[3], data[4]]
                Physics.shoot(screen, data[2][0], data[2][1], ball, game_data)
                currentPlayer = Constant.ID_2

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

                Display.draw_score(screen, game_data[1][0], game_data[1][1])
                Display.draw_active_player(screen, currentPlayer)

                pygame.display.update()

                if data[4] == 1: game_running = False
            else:
                data = client2.recv(BUFFER_SIZE)
                client1.send(data)
                data = pickle.loads(data)
                print("game data : ", data)
                game_data = [data[1], data[3], data[4]]
                Physics.shoot(screen, data[2][0], data[2][1], ball, game_data)
                currentPlayer = Constant.ID_1


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

                Display.draw_score(screen, game_data[1][0], game_data[1][1])
                Display.draw_active_player(screen, currentPlayer)

                pygame.display.update()

                if data[4] == 1: game_running = False

        # The game is finish, launch a new game
        time.sleep(0.5)

# the server is shutdown, send the shutdonw signal to the players
except:KeyboardInterrupt
print("end the server")
client1.send(pickle.dumps(-1))
client2.send(pickle.dumps(-1))
time.sleep(0.5)

pygame.quit()

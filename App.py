import pygame
import DisplayServer
import Display
import Physics
import math
import time


pygame.init()
WINDOW_SIZE = [1026, 512]
WINDOW_SIZE_SERVER = [1200, 720]
screen = pygame.display.set_mode(WINDOW_SIZE)
pygame.display.set_caption("Billard")
x1 = 0
y1 = 0
x2 = 0
y2 = 0
collision=0
is_start_point = False
LEFT = 1
RIGHT = 3

BORDER_X = 46
BORDER_Y = 23
BORDER = 40

SIZE = 13

MAX_X = 800
MAX_Y = 480

isActivePlayer = True

game_data = [1, [0, 0], 3]
done = False
shoot = False

ball = [[266, 263], # blanche
        [626, 263], # noir
        [603, 250], # 1
        [603, 276], # 2
        [626, 289], # 1
        [626, 237], # 2
        [649, 224], # 1
        [649, 250], # 2
        [649, 276], # 1
        [649, 302]] #2

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


clock = pygame.time.Clock()

while not done:
    #print(x_ball_1,y_ball_1)
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
                Display.draw_help(screen, (0, int(length/2.0), int(length/2.0)), ball[0], vector, 300)
                #Display.draw_line(screen, (0, int(length/2.0), int(length/2.0)), int(ball[0][0]), int(ball[0][1]), int(ball[0][0])+vector[0]*200, int(ball[0][1])+vector[1]*200, 4)
                Display.draw_line(screen, (128, 128, 128), x1, y1, x, y, 2)
    if isActivePlayer and shoot:
        # Send to the other player
        print("Send data")
        isActivePlayer = False
    else:
        # Wait data from the other player
        isActivePlayer = True
    if shoot:
        x_dir = (x2-x1)
        y_dir = (y2-y1)
        Physics.shoot(screen, x_dir, y_dir, ball, game_data)
        print("Player {:d} - {:d}".format(game_data[0], game_data[1][game_data[0]-1]))
        if game_data[0] == 1:
            game_data[0] = 2
        else :
            game_data[0] = 1
        shoot = False

    if game_data[2] == 1:
        # reset the game
        print("reset the game")
        time.sleep(5)
        isActivePlayer = True

        game_data = [1, [0, 0], 3]

        done = False
        shoot = False

        ball = [[250, 250],
                [600, 235],
                [600, 265]]

        Display.draw_background(screen)
        Display.draw_ball(screen, (255, 255, 255), ball[0])
        Display.draw_ball(screen, (255, 255, 0), ball[1])
        Display.draw_ball(screen, (255, 0, 255), ball[2])
        Display.draw_ball(screen, (255, 255, 0), ball[3])
        Display.draw_ball(screen, (255, 0, 255), ball[4])
        Display.draw_ball(screen, (255, 255, 0), ball[5])

    pygame.display.update()
pygame.quit()

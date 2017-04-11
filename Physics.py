import Display
import math
import pygame
import Logger

BORDER_X = 46
BORDER_Y = 23
BORDER = 40

SIZE = 13
WHOLE_SIZE = 16

MAX_X = 800
MAX_Y = 480

whole_list=[[86, 63],
            [446, 63],
            [806, 63],
            [86, 463],
            [446, 463],
            [806, 463]]


def shoot(screen, x, y, ball, game_data):
    length = math.sqrt(x * x + y * y)
    direction = [x / length, y / length]
    speed = min(length / 2.0, 400.0)

    score = game_data[1][game_data[0]-1]
    player = game_data[0]
    numberofball = game_data[2]

    velocity = [[direction[0]*speed/100.0, direction[1]*speed/100.0],   # ball 0
                [0, 0],                                                 # ball 1
                [0, 0],                                                 # ball 2
                [0, 0],                                                 # ball 3
                [0, 0],                                                 # ball 4
                [0, 0],                                                 # ball 5
                [0, 0],                                                 # ball 6
                [0, 0],                                                 # ball 7
                [0, 0],                                                 # ball 8
                [0, 0]]                                                 # ball 9

    border_collision = [[False, False, False, False],   # ball 0 0-> x_old, 1-> x_curr, 2 -> y_old, 3->y_curr
                        [False, False, False, False],   # ball 1
                        [False, False, False, False],   # ball 2
                        [False, False, False, False],   # ball 3
                        [False, False, False, False],   # ball 4
                        [False, False, False, False],   # ball 5
                        [False, False, False, False],   # ball 6
                        [False, False, False, False],   # ball 7
                        [False, False, False, False],   # ball 8
                        [False, False, False, False]]   # ball 9

    collision = [[False, False],  # ball 0 - 1
                 [False, False],  # ball 0 - 2
                 [False, False],  # ball 0 - 3
                 [False, False],  # ball 0 - 4
                 [False, False],  # ball 0 - 5
                 [False, False],  # ball 0 - 6
                 [False, False],  # ball 0 - 7
                 [False, False],  # ball 0 - 8
                 [False, False],  # ball 0 - 9
                 [False, False],  # ball 1 - 2
                 [False, False],  # ball 1 - 3
                 [False, False],  # ball 1 - 4
                 [False, False],  # ball 1 - 5
                 [False, False],  # ball 1 - 6
                 [False, False],  # ball 1 - 7
                 [False, False],  # ball 1 - 8
                 [False, False],  # ball 1 - 9
                 [False, False],  # ball 2 - 3
                 [False, False],  # ball 2 - 4
                 [False, False],  # ball 2 - 5
                 [False, False],  # ball 2 - 6
                 [False, False],  # ball 2 - 7
                 [False, False],  # ball 2 - 8
                 [False, False],  # ball 2 - 9
                 [False, False],  # ball 3 - 4
                 [False, False],  # ball 3 - 5
                 [False, False],  # ball 3 - 6
                 [False, False],  # ball 3 - 7
                 [False, False],  # ball 3 - 8
                 [False, False],  # ball 3 - 9
                 [False, False],  # ball 4 - 5
                 [False, False],  # ball 4 - 6
                 [False, False],  # ball 4 - 7
                 [False, False],  # ball 4 - 8
                 [False, False],  # ball 4 - 9
                 [False, False],  # ball 5 - 6
                 [False, False],  # ball 5 - 7
                 [False, False],  # ball 5 - 8
                 [False, False],  # ball 5 - 9
                 [False, False],  # ball 6 - 7
                 [False, False],  # ball 6 - 8
                 [False, False],  # ball 6 - 9
                 [False, False],  # ball 7 - 8
                 [False, False],  # ball 7 - 9
                 [False, False]]  # ball 8 - 9


    # list of collision [old, current]

    clock = pygame.time.Clock()

    Logger.logger.info("----------------shoot----------------")

    while speed > 0.10:

        border_collide(ball[0], velocity[0], border_collision[0])
        border_collide(ball[1], velocity[1], border_collision[1])
        border_collide(ball[2], velocity[2], border_collision[2])
        border_collide(ball[3], velocity[3], border_collision[3])
        border_collide(ball[4], velocity[4], border_collision[4])
        border_collide(ball[5], velocity[5], border_collision[5])
        border_collide(ball[6], velocity[6], border_collision[6])
        border_collide(ball[7], velocity[7], border_collision[7])
        border_collide(ball[8], velocity[8], border_collision[8])
        border_collide(ball[9], velocity[9], border_collision[9])

        # Move the ball
        move_ball(ball[0], velocity[0])
        move_ball(ball[1], velocity[1])
        move_ball(ball[2], velocity[2])
        move_ball(ball[3], velocity[3])
        move_ball(ball[4], velocity[4])
        move_ball(ball[5], velocity[5])
        move_ball(ball[6], velocity[6])
        move_ball(ball[7], velocity[7])
        move_ball(ball[8], velocity[8])
        move_ball(ball[9], velocity[9])

        if whole_collide(ball[0], velocity[0]):
            ball[0] = [250, 250]
            if score > 0 : score -= 1 # pas de score négatif

        if whole_collide(ball[1], velocity[1]):
            if numberofball == 2:
                score += 5
            else :
                if score > 0 : score -= 1
            numberofball -= 1

        if whole_collide(ball[2], velocity[2]):
            if player == 2:
                score += 5
            else:
                print("player 1 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[3], velocity[3]):
            if player == 1:
                score += 5
            else:
                print("player 2 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[4], velocity[4]):
            if player == 2:
                score += 5
            else:
                print("player 1 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[5], velocity[5]):
            if player == 1:
                score += 5
            else:
                print("player 2 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[6], velocity[6]):
            if player == 2:
                score += 5
            else:
                print("player 1 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[7], velocity[7]):
            if player == 1:
                score += 5
            else:
                print("player 2 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[8], velocity[8]):
            if player == 2:
                score += 5
            else:
                print("player 1 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1
        if whole_collide(ball[9], velocity[9]):
            if player == 1:
                score += 5
            else:
                print("player 2 a rentré la mauvaise balle")
                if score > 0 : score -= 1
            numberofball -= 1

        #Check collision with other ball
        collide(ball[0], ball[1], velocity[0], velocity[1], collision[0])
        collide(ball[0], ball[2], velocity[0], velocity[2], collision[1])
        collide(ball[0], ball[3], velocity[0], velocity[3], collision[2])
        collide(ball[0], ball[4], velocity[0], velocity[4], collision[3])
        collide(ball[0], ball[5], velocity[0], velocity[5], collision[4])
        collide(ball[0], ball[6], velocity[0], velocity[6], collision[5])
        collide(ball[0], ball[7], velocity[0], velocity[7], collision[6])
        collide(ball[0], ball[8], velocity[0], velocity[8], collision[7])
        collide(ball[0], ball[9], velocity[0], velocity[9], collision[8])

        collide(ball[1], ball[2], velocity[1], velocity[2], collision[9])
        collide(ball[1], ball[3], velocity[1], velocity[3], collision[10])
        collide(ball[1], ball[4], velocity[1], velocity[4], collision[11])
        collide(ball[1], ball[5], velocity[1], velocity[5], collision[12])
        collide(ball[1], ball[6], velocity[1], velocity[6], collision[13])
        collide(ball[1], ball[7], velocity[1], velocity[7], collision[14])
        collide(ball[1], ball[8], velocity[1], velocity[8], collision[15])
        collide(ball[1], ball[9], velocity[1], velocity[9], collision[16])

        collide(ball[2], ball[3], velocity[2], velocity[3], collision[17])
        collide(ball[2], ball[4], velocity[2], velocity[4], collision[18])
        collide(ball[2], ball[5], velocity[2], velocity[5], collision[19])
        collide(ball[2], ball[6], velocity[2], velocity[6], collision[20])
        collide(ball[2], ball[7], velocity[2], velocity[7], collision[21])
        collide(ball[2], ball[8], velocity[2], velocity[8], collision[22])
        collide(ball[2], ball[9], velocity[2], velocity[9], collision[23])

        collide(ball[3], ball[4], velocity[3], velocity[4], collision[24])
        collide(ball[3], ball[5], velocity[3], velocity[5], collision[25])
        collide(ball[3], ball[6], velocity[3], velocity[6], collision[26])
        collide(ball[3], ball[7], velocity[3], velocity[7], collision[27])
        collide(ball[3], ball[8], velocity[3], velocity[8], collision[28])
        collide(ball[3], ball[9], velocity[3], velocity[9], collision[29])

        collide(ball[4], ball[5], velocity[4], velocity[5], collision[30])
        collide(ball[4], ball[6], velocity[4], velocity[6], collision[31])
        collide(ball[4], ball[7], velocity[4], velocity[7], collision[32])
        collide(ball[4], ball[8], velocity[4], velocity[8], collision[33])
        collide(ball[4], ball[9], velocity[4], velocity[9], collision[34])

        collide(ball[5], ball[6], velocity[5], velocity[6], collision[35])
        collide(ball[5], ball[7], velocity[5], velocity[7], collision[36])
        collide(ball[5], ball[8], velocity[5], velocity[8], collision[37])
        collide(ball[5], ball[9], velocity[5], velocity[9], collision[38])

        collide(ball[6], ball[7], velocity[6], velocity[7], collision[39])
        collide(ball[6], ball[8], velocity[6], velocity[8], collision[40])
        collide(ball[6], ball[9], velocity[6], velocity[9], collision[41])

        collide(ball[7], ball[8], velocity[7], velocity[8], collision[42])
        collide(ball[7], ball[9], velocity[7], velocity[9], collision[43])

        collide(ball[8], ball[9], velocity[8], velocity[9], collision[44])

        # compute new collision vector
        vect_collide(ball[0], ball[1], velocity[0], velocity[1], collision[0])
        vect_collide(ball[0], ball[2], velocity[0], velocity[2], collision[1])
        vect_collide(ball[0], ball[3], velocity[0], velocity[3], collision[2])
        vect_collide(ball[0], ball[4], velocity[0], velocity[4], collision[3])
        vect_collide(ball[0], ball[5], velocity[0], velocity[5], collision[4])
        vect_collide(ball[0], ball[6], velocity[0], velocity[6], collision[5])
        vect_collide(ball[0], ball[7], velocity[0], velocity[7], collision[6])
        vect_collide(ball[0], ball[8], velocity[0], velocity[8], collision[7])
        vect_collide(ball[0], ball[9], velocity[0], velocity[9], collision[8])

        vect_collide(ball[1], ball[2], velocity[1], velocity[2], collision[9])
        vect_collide(ball[1], ball[3], velocity[1], velocity[3], collision[10])
        vect_collide(ball[1], ball[4], velocity[1], velocity[4], collision[11])
        vect_collide(ball[1], ball[5], velocity[1], velocity[5], collision[12])
        vect_collide(ball[1], ball[6], velocity[1], velocity[6], collision[13])
        vect_collide(ball[1], ball[7], velocity[1], velocity[7], collision[14])
        vect_collide(ball[1], ball[8], velocity[1], velocity[8], collision[15])
        vect_collide(ball[1], ball[9], velocity[1], velocity[9], collision[16])

        vect_collide(ball[2], ball[3], velocity[2], velocity[3], collision[17])
        vect_collide(ball[2], ball[4], velocity[2], velocity[4], collision[18])
        vect_collide(ball[2], ball[5], velocity[2], velocity[5], collision[19])
        vect_collide(ball[2], ball[6], velocity[2], velocity[6], collision[20])
        vect_collide(ball[2], ball[7], velocity[2], velocity[7], collision[21])
        vect_collide(ball[2], ball[8], velocity[2], velocity[8], collision[22])
        vect_collide(ball[2], ball[9], velocity[2], velocity[9], collision[23])

        vect_collide(ball[3], ball[4], velocity[3], velocity[4], collision[24])
        vect_collide(ball[3], ball[5], velocity[3], velocity[5], collision[25])
        vect_collide(ball[3], ball[6], velocity[3], velocity[6], collision[26])
        vect_collide(ball[3], ball[7], velocity[3], velocity[7], collision[27])
        vect_collide(ball[3], ball[8], velocity[3], velocity[8], collision[28])
        vect_collide(ball[3], ball[9], velocity[3], velocity[9], collision[29])

        vect_collide(ball[4], ball[5], velocity[4], velocity[5], collision[30])
        vect_collide(ball[4], ball[6], velocity[4], velocity[6], collision[31])
        vect_collide(ball[4], ball[7], velocity[4], velocity[7], collision[32])
        vect_collide(ball[4], ball[8], velocity[4], velocity[8], collision[33])
        vect_collide(ball[4], ball[9], velocity[4], velocity[9], collision[34])

        vect_collide(ball[5], ball[6], velocity[5], velocity[6], collision[35])
        vect_collide(ball[5], ball[7], velocity[5], velocity[7], collision[36])
        vect_collide(ball[5], ball[8], velocity[5], velocity[8], collision[37])
        vect_collide(ball[5], ball[9], velocity[5], velocity[9], collision[38])

        vect_collide(ball[6], ball[7], velocity[6], velocity[7], collision[39])
        vect_collide(ball[6], ball[8], velocity[6], velocity[8], collision[40])
        vect_collide(ball[6], ball[9], velocity[6], velocity[9], collision[41])

        vect_collide(ball[7], ball[8], velocity[7], velocity[8], collision[42])
        vect_collide(ball[7], ball[9], velocity[7], velocity[9], collision[43])

        vect_collide(ball[8], ball[9], velocity[8], velocity[9], collision[44])

        # Dumping factor
        damping(velocity[0])
        damping(velocity[1])
        damping(velocity[2])
        damping(velocity[3])
        damping(velocity[4])
        damping(velocity[5])
        damping(velocity[6])
        damping(velocity[7])
        damping(velocity[8])
        damping(velocity[9])

        total_speed =   momentum(velocity[0]) \
                      + momentum(velocity[1]) \
                      + momentum(velocity[2]) \
                      + momentum(velocity[3]) \
                      + momentum(velocity[4]) \
                      + momentum(velocity[5]) \
                      + momentum(velocity[6]) \
                      + momentum(velocity[7]) \
                      + momentum(velocity[8]) \
                      + momentum(velocity[9])
        speed = total_speed

        Logger.log_ball(ball, velocity)

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
        clock.tick(500) # wait 20 ms

    game_data[1][game_data[0]-1] = score
    game_data[2] = numberofball


def collide(ball1, ball2, velocity1 , velocity2, collision):
    collision[0] = collision[1]
    x1 = ball1[0] + velocity1[0]
    x2 = ball2[0] + velocity2[0]

    y1 = ball1[1] + velocity1[1]
    y2 = ball2[1] + velocity2[1]

    dx = x2-x1
    dy = y2-y1

    collision[1] = dx*dx + dy*dy <= 4*SIZE*SIZE

def border_collide(ball, velocity, border_collision):
    new_velocity = velocity
    border_collision[0] = border_collision[1]
    border_collision[2] = border_collision[3]

    # position on the next tick
    x = ball[0] + velocity[0]
    y = ball[1] + velocity[1]

    #check if the ball will touch the border on the next update
    border_collision[1] = x < BORDER_X + BORDER + SIZE or x > (MAX_X + BORDER_X) - (BORDER + SIZE)
    border_collision[3] = y < BORDER_Y + BORDER + SIZE or y > (MAX_Y + BORDER_Y) - (BORDER + SIZE)
        #collide_y = True

    # si collision détectée
    if not border_collision[0] and border_collision[1]:
        Logger.logger.debug("collision x")
        new_velocity[0] = 0-velocity[0]

    # si collision détectée
    if not border_collision[2] and border_collision[3]:
        Logger.logger.debug("collision y")
        new_velocity[1] = 0-velocity[1]

    return [new_velocity, border_collision]


def vect_collide(ball1, ball2, v1, v2, collision):
    if not collision[0] and collision[1]:
        x1 = ball1[0]
        x2 = ball2[0]
        y1 = ball1[1]
        y2 = ball2[1]

        m1 = 1.0
        m2 = 1.0
        m21 = m2/m1
        x21 = x2 - x1
        y21 = y2 - y1
        v21 = [v2[0] - v1[0], v2[1] - v1[1]]

        #v_cm = [(m1 * v1[0] + m2 * v2[0])/(m1+m2), (m1 * v1[1] + m2 * v2[1])/(m1+m2)]

        if v21[0]*x21 + v21[1]*y21 >= 0:
            Logger.logger.info("error in collision")
            return [x1, y1, x2, y2, v1, v2]
        else:
            fy21 = 1.0E-6*math.fabs(y21)
            if math.fabs(x21) < fy21:
                if x21<0 : sign = -1
                else: sign = 1
                x21=fy21*sign

            a = y21/x21
            dv = -2.0*(v21[0]+a*v21[1])/((1+a*a)*(1+m21))
            v2[0] += dv
            v2[1] += a*dv

            v1[0] -= m21*dv
            v1[1] -= a*m21*dv


def move_ball(ball, velocity):
    ball[0] += velocity[0]
    ball[1] += velocity[1]


def damping(velocity):
    velocity[0] *= 0.995
    velocity[1] *= 0.995


def momentum(velocity):
    return math.sqrt(velocity[0]*velocity[0]+velocity[1]*velocity[1])


def whole_collide(ball, velocity):
    x = ball[0]+velocity[0]
    y = ball[1]+velocity[1]

    collision = False

    for whole in whole_list:
        dx = whole[0]-x
        dy = whole[1]-y
        collision = collision or dx*dx + dy*dy <= (SIZE+WHOLE_SIZE)*(SIZE+WHOLE_SIZE)*0.85
    if collision:
        ball[0] = 0
        ball[1] = 0
        velocity[0] = 0
        velocity[1] = 0
    return collision
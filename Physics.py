import Display
import math
import pygame
from Logger import logger

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
            [806, 63]]


def shoot(screen, x, y, ball):
    length = math.sqrt(x * x + y * y)
    direction = [x / length, y / length]
    speed = min(length / 2.0, 400.0)

    velocity = [[direction[0]*speed/100.0, direction[1]*speed/100.0],   # ball 0
                [0, 0],                                                 # ball 1
                [0, 0]]                                                 # ball 2

    border_collision = [[False, False, False, False],   # ball 0 0-> x_old, 1-> x_curr, 2 -> y_old, 3->y_curr
                        [False, False, False, False],   # ball 1
                        [False, False, False, False]]   # ball 2

    collision = [[False, False], # ball 0 - 1
                 [False, False], # ball 0 - 2
                 [False, False]] # ball 1 - 2
    # list of collision [old, current]

    clock = pygame.time.Clock()

    logger.info("----------------shoot----------------")

    while speed > 0.10:

        # Border Collide
        #border_collision[0][0] = border_collision[0][1]
        #border_collision[0][2] = border_collision[0][3]
        #border_collision[1][0] = border_collision[1][1]
        #border_collision[1][2] = border_collision[1][3]
        #border_collision[2][0] = border_collision[2][1]
        #border_collision[2][2] = border_collision[2][3]

        border_collide(ball[0], velocity[0], border_collision[0])
        border_collide(ball[1], velocity[1], border_collision[1])
        border_collide(ball[2], velocity[2], border_collision[2])

        # Move the ball
        move_ball(ball[0], velocity[0])
        move_ball(ball[1], velocity[1])
        move_ball(ball[2], velocity[2])

        whole_collide(ball[0], velocity[0])
        whole_collide(ball[1], velocity[1])
        whole_collide(ball[2], velocity[2])

        #Check collision with other ball
        collide(ball[0], ball[1], velocity[0], velocity[1], collision[0])
        collide(ball[0], ball[2], velocity[0], velocity[2], collision[1])
        collide(ball[1], ball[2], velocity[1], velocity[2], collision[2])

        vect_collide(ball[0], ball[1], velocity[0], velocity[1], collision[0])
        vect_collide(ball[0], ball[2], velocity[0], velocity[2], collision[1])
        vect_collide(ball[1], ball[2], velocity[1], velocity[2], collision[2])

        # collision[0] = collision[1]
        # collision[1] = collide(x_ball_1, y_ball_1, x_ball_2, y_ball_2)
        # if not collision[0] and collision[1]:  # old = 0; current = 1 -> posedge
        #     logger.info(
        #         "collision before : ball 1 -> ({:.1f}, {:.1f}) \t ball 2 -> ({:.1f}, {:.1f})".format(velocity_1[0],
        #                                                                                              velocity_1[1],
        #                                                                                              velocity_2[0],
        #                                                                                              velocity_2[1]))
        #     (x_ball_1, Y, x_ball_2, y_ball_2, velocity_1, velocity_2) = vect_collide(x_ball_1, y_ball_1, x_ball_2,
        #                                                                              y_ball_2, velocity_1, velocity_2)
        #     logger.info(
        #         "collision after  : ball 1 -> ({:.1f}, {:.1f}) \t ball 2 -> ({:.1f}, {:.1f})".format(velocity_1[0],
        #                                                                                              velocity_1[1],
        #                                                                                              velocity_2[0],
        #                                                                                              velocity_2[1]))

        # Dumping factor
        #speed = math.fabs(velocity_1[0]) + math.fabs(velocity_1[1]) + math.fabs(velocity_2[0]) + math.fabs(velocity_2[1])

        damping(velocity[0])
        damping(velocity[1])
        damping(velocity[2])

        total_speed = momentum(velocity[0]) + momentum(velocity[1]) + momentum(velocity[2])
        speed = total_speed

        logger.debug("{:s} \t {:s} \t {:s}".format(ball_info(1, ball[0], velocity[0]), ball_info(2, ball[1], velocity[1]), ball_info(3, ball[2], velocity[2])))

        Display.draw_background(screen)
        Display.draw_ball(screen, (255, 255, 255), ball[0])
        Display.draw_ball(screen, (255, 255,0), ball[1])
        Display.draw_ball(screen, (255, 0, 255), ball[2])
        pygame.display.update()
        clock.tick(500) # wait 20 ms
    #return [ball]


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
        logger.debug("collision x")
        new_velocity[0] = 0-velocity[0]

    # si collision détectée
    if not border_collision[2] and border_collision[3]:
        logger.debug("collision y")
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
            logger.info("error in collision")
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
        collision = collision or dx*dx + dy*dy <= (SIZE+WHOLE_SIZE)*(SIZE+WHOLE_SIZE)*0.75
    if collision:
        ball[0] = 0
        ball[1] = 0
        velocity[0] = 0
        velocity[1] = 0
    return collision


def ball_info(num, ball, velocity):
    return "ball {:d} @({:.2f}, {:.2f}) moving @({:.2f}, {:.2f})".format(num, ball[0], ball[1], velocity[0], velocity[1])
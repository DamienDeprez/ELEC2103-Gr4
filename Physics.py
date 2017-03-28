import Display
import math
import pygame

BORDER_X = 16
BORDER_Y = 10
BORDER = 40

SIZE = 13

MAX_X = 800
MAX_Y = 480


def shoot(screen, x, y, x_ball_1, y_ball_1,x_ball_2,y_ball_2):
    length = math.sqrt(x * x + y * y)
    direction = [x / length, y / length]
    speed = length / 2.0

    velocity_1 = [direction[0]*speed/10.0, direction[1]*speed/10.0]
    velocity_2 = [0,0]

    border_collision = [[False, False, False, False],    # ball 1 0-> x_old, 1-> x_curr, 2 -> y_old, 3->y_curr
                        [False, False, False, False]]   # ball 2

    collision = [False, False] # list of collision [old, current]

    clock = pygame.time.Clock()

    print(velocity_1)

    while speed >= 0.5:

        # Border Collide
        border_collision[0][0] = border_collision[0][1]
        border_collision[0][2] = border_collision[0][3]
        border_collision[1][0] = border_collision[1][1]
        border_collision[1][2] = border_collision[1][3]

        [velocity_1, border_collision[0][1], border_collision[0][3]] = border_collide(x_ball_1, y_ball_1, velocity_1, border_collision[0])
        [velocity_2, border_collision[1][1], border_collision[1][3]] = border_collide(x_ball_2, y_ball_2, velocity_2, border_collision[1])

        # Move the ball
        x_ball_1 += velocity_1[0]
        y_ball_1 += velocity_1[1]
        x_ball_2 += velocity_2[0]
        y_ball_2 += velocity_2[1]

        # Dumping factor
        speed = math.fabs(velocity_1[0]) + math.fabs(velocity_1[1]) + math.fabs(velocity_2[0]) + math.fabs(velocity_2[1])

        velocity_1[0] *= 0.98
        velocity_1[1] *= 0.98

        velocity_2[0] *= 0.98
        velocity_2[1] *= 0.98

        collision[0] = collision[1]
        collision[1] = collide(x_ball_1,y_ball_1,x_ball_2,y_ball_2)
        if not collision[0] and collision[1]: # old = 0; current = 1 -> posedge
                 print("collision before : ball 1 -> ({:.1f}, {:.1f}) \t ball 2 -> ({:.1f}, {:.1f})".format(velocity_1[0], velocity_1[1], velocity_2[0], velocity_2[1]))
                 (x_ball_1, Y, x_ball_2, y_ball_2, velocity_1, velocity_2) = vect_collide(x_ball_1,y_ball_1,x_ball_2,y_ball_2, velocity_1, velocity_2)
                 print("collision after  : ball 1 -> ({:.1f}, {:.1f}) \t ball 2 -> ({:.1f}, {:.1f})".format(velocity_1[0], velocity_1[1], velocity_2[0], velocity_2[1]))

        Display.draw_background(screen)
        Display.draw_ball(screen, (255, 255, 255), int(x_ball_1), int(y_ball_1))
        Display.draw_ball(screen, (255, 255,0), int(x_ball_2), int(y_ball_2))
        pygame.display.update()
        clock.tick(60)
    return [x_ball_1, y_ball_1, x_ball_2, y_ball_2]


def collide(x_ball_1, y_ball_1,x_ball_2,y_ball_2):
    if (math.sqrt((x_ball_2-x_ball_1)*(x_ball_2-x_ball_1)+(y_ball_1-y_ball_2)*(y_ball_1-y_ball_2)) <= (2*SIZE)):
        return True
    else:
        return False
 
def border_collide(x_ball,y_ball, vector, border_collision):
    collide_x = False
    collide_y = False
    new_dir = vector

    #check if the ball touch the border
    if x_ball < BORDER_X + BORDER + SIZE or x_ball > (MAX_X + BORDER_X) - (BORDER + SIZE):
        collide_x = True

    if y_ball < BORDER_Y + BORDER + SIZE or y_ball > (MAX_Y + BORDER_Y) - (BORDER + SIZE): 
        collide_y = True

    # si collision détectée
    if not border_collision[0] and collide_x:
        print("collision x")
        if not collide_x:
            new_dir[0] = vector[0]
        else:
            new_dir[0] = 0-vector[0]

    # si collision détectée
    if not border_collision[2] and collide_y:
        print("collision y")
        if not collide_y:
            new_dir[1] = vector[1]
        else:
            new_dir[1] = 0-vector[1]

    return [new_dir, collide_x, collide_y]

    

def vect_collide(x_ball_1,y_ball_1,x_ball_2,y_ball_2, velocity_1, velocity_2):#,vector1,vector2,speed1,speed2):
    delta = [x_ball_2 - x_ball_1, y_ball_2 - y_ball_1]
    print(print("delta : ({:.2f}, {:.2f})".format(delta[0], delta[1])))
    d = delta[0]*delta[0] + delta[1]*delta[1]
    if d == 0:
        print("d == 0")
        d = SIZE - 1
        delta[0] *= SIZE
        delta[1] *= SIZE

    print("d = {:.2f}".format(d))
    mtd = delta
    mtd[0] *= (SIZE-d)/d
    mtd[1] *= (SIZE-d)/d

    print("mtd : ({:.2f}, {:.2f})".format(mtd[0], mtd[1]))

    correction = mtd
    correction[0] *= 0.5
    correction[1] *= 0.5

    print("correction : ({:.2f}, {:.2f})".format(correction[0], correction[1]))

    x_ball_1 += correction[0]/4.0
    y_ball_1 += correction[1]/4.0
    x_ball_2 -= correction[0]/4.0
    y_ball_2 -= correction[1]/4.0

    # Calcul de la base orthonormée
    nx = (x_ball_2 - x_ball_1) / float(SIZE)
    ny = (y_ball_2 - y_ball_1) / float(SIZE)

    gx = -ny
    gy = nx

    print("base orthonormée : n -> ({:.2f}, {:.2f}) \t g -> ({:.2f}, {:.2f})".format(nx, ny, gx, gy))


    # Calcul des vitesse dans la base orthonormée
    v1n = nx * velocity_1[0] + ny * velocity_1[1]
    v1g = gx * velocity_1[0] + gy * velocity_1[1]

    v2n = nx * velocity_2[0] + ny * velocity_2[1]
    v2g = gx * velocity_2[0] + gy * velocity_2[1]

    velocity_1[0] = nx * v2n + gx * v1g
    velocity_1[1] = ny * v2n + gy * v1g

    velocity_2[0] = nx * v1n + gx * v2g
    velocity_2[1] = ny * v1n + gx * v2g

    return[x_ball_1, y_ball_1, x_ball_2, y_ball_2, velocity_1, velocity_2]

    #central_vector = [x_ball_1-x_ball_2,y_ball_1-y_ball_2]
    #length_central_vector = math.sqrt((x_ball_1-x_ball_2)*(x_ball_1-x_ball_2)+(y_ball_1-y_ball_2)*(y_ball_1-y_ball_2))
    #final_vector_1 = [central_vector[0]/length_central_vector, central_vector[1]/length_central_vector]
    #final_vector_2 = [-1*final_vector_1[1],final_vector_1[0]]
    #return [final_vector_1, final_vector_2]

 












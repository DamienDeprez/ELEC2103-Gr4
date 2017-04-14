import pygame
BLACK = (0, 0, 0)
FACTOR = 1.5
XBORDER = 46
YBORDER = 23


def draw_rounded_rectangle(screen, color, x0, y0, width, height, radius):
    rect1 = [x0, y0+radius, width, height - 2*radius]
    rect2 = [x0+radius, y0, width - 2*radius, height]
    pygame.draw.rect(screen, color, rect1)
    pygame.draw.rect(screen, color, rect2)
    pygame.draw.circle(screen, color, [x0+radius, y0+radius], radius)
    pygame.draw.circle(screen, color, [x0 + width - radius, y0 + radius], radius)
    pygame.draw.circle(screen, color, [x0 + radius, y0 + height - radius], radius)
    pygame.draw.circle(screen, color, [x0 +width - radius, y0 + height - radius], radius)


def draw_ball(screen, color, ball):
    x = int((ball[0]-XBORDER)*FACTOR)
    y = int((ball[1]-YBORDER)*FACTOR)
    pygame.draw.circle(screen, color, [x, y], 20)


def draw_line(screen, color, x1, y1, x2, y2, width):
    pygame.draw.line(screen, color, (x1, y1), (x2, y2), width)


def draw_help(screen, color, ball, vector, length):
    x1 = int((ball[0]-XBORDER)*FACTOR)
    y1 = int((ball[1]-YBORDER)*FACTOR)

    x2 = x1+vector[0]*length
    y2 = y1+vector[1]*length
    pygame.draw.line(screen, color, (x1,y1), (x2,y2), 4)


def draw_background(screen):
    screen.fill(BLACK)
    #pygame.draw.rect(screen, (255, 255, 255), [46, 23, 800, 480]) # draw the visible part of the screen
    draw_rounded_rectangle(screen, (67, 46, 14), 0, 0, 1200, 720, 45) #
    draw_rounded_rectangle(screen, (12, 53, 30), 15, 15, 1170, 690, 30)
    draw_rounded_rectangle(screen, (0, 96, 41), 60, 60, 1080, 600, 0)
    # draw the whole
    pygame.draw.circle(screen, (0, 0, 0), [60, 60], 24)
    pygame.draw.circle(screen, (0, 0, 0), [600, 60], 24)
    pygame.draw.circle(screen, (0, 0, 0), [1140, 60], 24)
    pygame.draw.circle(screen, (0, 0, 0), [60, 660], 24)
    pygame.draw.circle(screen, (0, 0, 0), [600, 660], 24)
    pygame.draw.circle(screen, (0, 0, 0), [1140, 660], 24)



def draw_score(screen, player1, player2):
    font = pygame.font.SysFont(None, int(29*FACTOR)) # heigth of 20
    text1 = font.render("{:d}".format(player2), True, (255, 255, 0))
    text2 = font.render("{:d}".format(player1), True, (255, 0, 0))
    screen.blit(text1,(int((226-XBORDER)*FACTOR)-text1.get_width()//2, int((38-YBORDER)*FACTOR)))
    screen.blit(text2,(int((626-XBORDER)*FACTOR)-text2.get_width()//2, int((38-YBORDER)*FACTOR)))


def draw_active_player(screen, player):
    if player == 2:
        pygame.draw.rect(screen, (255, 255, 0), [int((61-XBORDER)*FACTOR), int((163-YBORDER)*FACTOR), int(20*FACTOR), int(200*FACTOR)])
    else:
        pygame.draw.rect(screen, (255, 0, 0), [int((811-XBORDER)*FACTOR), int((163-YBORDER)*FACTOR), int(20*FACTOR), int(200*FACTOR)])




import pygame
BLACK = (0, 0, 0)


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
    pygame.draw.circle(screen, color, [int(ball[0]), int(ball[1])], 13)


def draw_line(screen, color, x1, y1, x2, y2, width):
    pygame.draw.line(screen, color, (x1, y1), (x2, y2), width)


def draw_background(screen):
    screen.fill(BLACK)
    pygame.draw.rect(screen, (255, 255, 255), [46, 23, 800, 480]) # draw the visible part of the screen
    draw_rounded_rectangle(screen, (67, 46, 14), 46, 23, 800, 480, 30) #
    draw_rounded_rectangle(screen, (12, 53, 30), 56, 33, 780, 460, 25)
    draw_rounded_rectangle(screen, (0, 96, 41), 86, 63, 720, 400, 0)
    # draw the whole
    pygame.draw.circle(screen, (0, 0, 0), [86, 63], 16)
    pygame.draw.circle(screen, (0, 0, 0), [446, 63], 16)
    pygame.draw.circle(screen, (0, 0, 0), [806, 63], 16)
    pygame.draw.circle(screen, (0, 0, 0), [86, 463], 16)
    pygame.draw.circle(screen, (0, 0, 0), [446, 463], 16)
    pygame.draw.circle(screen, (0, 0, 0), [806, 463], 16)




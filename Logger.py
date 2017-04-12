import logging
from logging.handlers import RotatingFileHandler

# ************************************************
# *                    Logger                    *
# ************************************************
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s :: %(levelname)s :: %(message)s')
file_handler = logging.handlers.RotatingFileHandler('Billard.log', 'a', 10485760, 20) # max size : 10M
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)

logger.addHandler(file_handler)


def ball_info(num, ball, velocity):
    return "ball {:d} @({:.2f}, {:.2f}) moving @({:.2f}, {:.2f})".format(num, ball[0], ball[1], velocity[0], velocity[1])


def log_ball(ball, velocity):
    logger.debug("------------------------------")
    logger.debug("{:s}".format(ball_info(0, ball[0], velocity[0])))
    logger.debug("{:s}".format(ball_info(1, ball[1], velocity[1])))
    logger.debug("{:s}".format(ball_info(2, ball[2], velocity[2])))
    logger.debug("{:s}".format(ball_info(3, ball[3], velocity[3])))
    logger.debug("{:s}".format(ball_info(4, ball[4], velocity[4])))
    logger.debug("{:s}".format(ball_info(5, ball[5], velocity[5])))
    logger.debug("{:s}".format(ball_info(6, ball[6], velocity[6])))
    logger.debug("{:s}".format(ball_info(7, ball[7], velocity[7])))
    logger.debug("{:s}".format(ball_info(8, ball[8], velocity[8])))
    logger.debug("{:s}".format(ball_info(9, ball[9], velocity[9])))
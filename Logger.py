import logging
from logging.handlers import RotatingFileHandler

# ************************************************
# *                    Logger                    *
# ************************************************
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s :: %(levelname)s :: %(message)s')
file_handler = logging.handlers.RotatingFileHandler('Billard.log', 'a', 1048576, 1) # max size : 1M
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)

logger.addHandler(file_handler)

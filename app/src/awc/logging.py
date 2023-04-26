import logging
import os


def configure_logger():
    log_level = os.environ.get('LOG_LEVEL') or 'DEBUG'
    log_level_as_number = getattr(logging, log_level.upper(), None)
    if not isinstance(log_level_as_number, int):
        raise ValueError('Invalid log level: %s' % log_level)
    logger = logging.getLogger(__name__)
    logger.setLevel(log_level_as_number)
    return logger
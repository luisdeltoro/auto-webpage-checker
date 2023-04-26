import logging
import os


def configure_logging():
    log_level = os.environ.get('LOG_LEVEL') or 'INFO'
    log_level_as_number = getattr(logging, log_level.upper(), None)
    print(f"Setting log level to {log_level}")
    if not isinstance(log_level_as_number, int):
        raise ValueError('Invalid log level: %s' % log_level)
    logging.basicConfig(level=log_level_as_number)
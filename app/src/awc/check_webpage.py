import os

from awc.berlin_appointment_strategy import BerlinAppointmentStrategy
from awc.logging import configure_logger

logger = configure_logger()

def handler(event, context):
    logger.debug("Lambda started")
    strategy = select_strategy()
    success = strategy.execute()
    logger.info("Lambda finished with success=" + str(success))

def select_strategy():
    strategy = os.environ.get('STRATEGY') or 'BERLIN_APPOINTMENT'
    logger.debug('Selected strategy: %s' % strategy)
    if strategy == 'BERLIN_APPOINTMENT':
        return BerlinAppointmentStrategy()
    else:
        raise ValueError('Invalid strategy: %s' % strategy)
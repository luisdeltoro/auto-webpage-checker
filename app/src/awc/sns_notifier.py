import os

import boto3

from awc.logging import configure_logger

logger = configure_logger()

class SnsNotifier:
    def __init__(self):
        self.topic_arn = os.environ.get('SNS_TOPIC_ARN') or 'arn:aws:sns:us-east-1:123456789012:awc-main-topic'
        aws_region=os.environ.get('AWS_REGION') or 'us-east-1'
        self.sns_client = boto3.client('sns', region_name=aws_region)

    def send_notification(self, message):
        logger.debug(f"Sending notification: {message} to topic: {self.topic_arn}")
        response = self.sns_client.publish(
            TopicArn=self.topic_arn,
            Message=message
        )
        logger.info(f"Message published with ID: {response['MessageId']}")



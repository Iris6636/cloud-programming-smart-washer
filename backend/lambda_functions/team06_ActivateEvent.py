import boto3
import json
import logging
import os
from datetime import datetime

# 設定 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

scheduler = boto3.client('scheduler')
TARGET_LAMBDA_ARN = os.environ['TARGET_LAMBDA_ARN']
ROLE_ARN = os.environ['SCHEDULER_ROLE_ARN']
def lambda_handler(event, context):
    logger.info("Event received:\n%s", json.dumps(event, indent=2))

    for record in event['Records']:
        logger.info(f"Processing record: {json.dumps(record)}")

        if record['eventName'] == 'MODIFY':
            new_image = record['dynamodb']['NewImage']
            washer_id = int(new_image['washer_id']['N'])
            in_use = new_image.get('in_use', {}).get('BOOL')
            reserved = new_image.get('reserved', {}).get('BOOL')
            door_locked = new_image.get('door_locked', {}).get('BOOL')
            expire_at = new_image.get('expire_at', {}).get('N')

            logger.info(f"Washer {washer_id} - door_locked: {door_locked}, in_use: {in_use}, reserved: {reserved}, expire_at: {expire_at}")

            if not in_use and reserved and not door_locked and expire_at:
                schedule_time = datetime.utcfromtimestamp(int(expire_at)).isoformat(timespec='seconds')
                schedule_name = f"team06_expire-check-washer-{washer_id}-{expire_at}"

                payload = {
                    "washer_id": washer_id,
                    "expire_at": int(expire_at)
                }

                try:
                    response = scheduler.create_schedule(
                        Name=schedule_name,
                        ScheduleExpression=f"at({schedule_time})",
                        FlexibleTimeWindow={"Mode": "OFF"},
                        Target={
                            "Arn": TARGET_LAMBDA_ARN,
                            "RoleArn": ROLE_ARN,
                            "Input": json.dumps(payload)
                        }
                    )
                    logger.info(f"Scheduler created: {response}")
                    print("Scheduled for:", schedule_time)
                except Exception as e:
                    logger.error(f"Failed to create scheduler: {e}")
            else:
                logger.info("Condition not met for starting Event Bridge")
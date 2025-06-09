import boto3
import json
import logging


dynamodb = boto3.resource('dynamodb')
iot_data = boto3.client('iot-data', region_name='us-east-1')  # 用來更新 device shadow
thing_name = "team06_IoT"

# 設定 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Received event: {event}")
    washer_id = int(event.get('washer_id'))  # 轉為數字

    if not washer_id:
        return {'statusCode': 400, 'body': 'Missing washer_id'}

    # 更新 DynamoDB
    table = dynamodb.Table('team06-WasherStatus')
    try:
        table.update_item(
            Key={'washer_id': washer_id},
            UpdateExpression='SET door_locked = :d',
            ExpressionAttributeValues={
                ':d': False
            }
        )
        logger.info(f"DynamoDB updated for washer_id {washer_id}")
    except Exception as e:
        logger.error(f"Failed to update DynamoDB: {e}")
        return {'statusCode': 500, 'body': 'DynamoDB update failed'}

    return {
        'statusCode': 200,
        'body': 'Washer status updated'
    }


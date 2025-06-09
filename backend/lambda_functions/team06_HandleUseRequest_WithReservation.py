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
    user_id = event.get('user_id')

    if not washer_id:
        return {'statusCode': 400, 'body': 'Missing washer_id'}
    
    if not user_id:
        return {'statusCode': 400, 'body': 'Missing user_id'}

    # 更新 DynamoDB
    table1 = dynamodb.Table('team06-WasherStatus')
    try:
        table1.update_item(
            Key={'washer_id': washer_id},
            UpdateExpression='SET in_use = :d, reserved = :r REMOVE expire_at',
            ExpressionAttributeValues={
                ':d': True,
                ':r': False
            }
        )
        logger.info(f"DynamoDB updated for washer_id {washer_id}")
    except Exception as e:
        logger.error(f"Failed to update DynamoDB: {e}")
        return {'statusCode': 500, 'body': 'DynamoDB update WasherStatus failed'}

    table2 = dynamodb.Table('team06-UserInfo')
    try:
        table2.update_item(
            Key={'user_id': user_id},
            UpdateExpression='SET in_use = :r REMOVE reserved',
            ExpressionAttributeValues={
                ':r': washer_id
            }
        )
        logger.info(f"DynamoDB updated for user_id {user_id}")
    except Exception as e:
        logger.error(f"Failed to update DynamoDB: {e}")
        return {'statusCode': 500, 'body': 'DynamoDB update UserInfo failed'}

    # 發送 desired 狀態到 Device Shadow
    shadow_payload = {
        "state": {
            "desired": {
                "door_locked": False,
                "unlock_reason": "reserve_related"
            }
        }
    }

    try:
        iot_data.update_thing_shadow(
            thingName=thing_name,
            payload=json.dumps(shadow_payload)
        )
        logger.info(f"Device shadow update requested for washer_id {washer_id}")
    except Exception as e:
        logger.error(f"Failed to update device shadow: {e}")
        return {'statusCode': 500, 'body': 'Device shadow update failed'}

    return {
        'statusCode': 200,
        'headers': {
            "Access-Control-Allow-Origin": "http://team06website.s3-website-us-east-1.amazonaws.com",
            "Access-Control-Allow-Methods": "POST,OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type,Authorization"
        },
        'body': 'Deivce Shadow, Washer & User status updated'
    }


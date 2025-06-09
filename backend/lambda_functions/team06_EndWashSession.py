import boto3
import json
import logging
import time
from datetime import datetime, timedelta
import os

dynamodb = boto3.resource('dynamodb')
iot_data = boto3.client('iot-data', region_name='us-east-1')  # 用來更新 device shadow
thing_name = "team06_IoT"
lambda_client = boto3.client('lambda')
scheduler = boto3.client('scheduler')
SNS_LAMBDA_NAME = 'team06-SendReservedUserNotification'
TARGET_LAMBDA_ARN = os.environ['TARGET_LAMBDA_ARN']
ROLE_ARN = os.environ['SCHEDULER_ROLE_ARN']

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
            UpdateExpression='SET in_use = :i',
            ExpressionAttributeValues={
                ':i': False
            }
        )
        logger.info(f"DynamoDB updated for washer_id {washer_id}")
    except Exception as e:
        logger.error(f"Failed to update DynamoDB: {e}")
        return {'statusCode': 500, 'body': 'DynamoDB update failed'}

    # 查詢 reserved 狀態
    washer = table.get_item(Key={'washer_id': washer_id}).get('Item', {})
    # 無人預約時
    if not washer.get('reserved'):
        logger.info("No reservation. No action needed.")
        return {'statusCode': 200, 'body': 'Washer unlocked and ready'}
    # 有人預約時，查找 user_id who reserved this washer
    user_table = dynamodb.Table('team06-UserInfo')
    result = user_table.scan(
        FilterExpression='reserved = :wid',
        ExpressionAttributeValues={':wid': washer_id}
    )
    if not result['Items']:
        logger.warning("Washer reserved but no matching user found.")
        return {'statusCode': 500, 'body': 'Reserved user not found'}
    
    user = result['Items'][0]
    user_id = user['user_id']
    email = user['email']
    # 呼叫另一個 Lambda 發送 SNS 通知
    lambda_client.invoke(
        FunctionName=SNS_LAMBDA_NAME,
        InvocationType='Event',
        Payload=json.dumps({
            'user_id': user_id,
            'washer_id': int(washer_id),
            'user_email': email
        })
    )

    # 設定 expire_at 為目前時間 + 300 秒（5 分鐘）
    expire_ts = int(time.time()) + 300
    table.update_item(
        Key={'washer_id': washer_id},
        UpdateExpression='SET expire_at = :exp',
        ExpressionAttributeValues={':exp': expire_ts}
    )
    
    schedule_shadow_update(washer_id)

    return {
        'statusCode': 200,
        'body': 'DynamoDB updated, other function has been called to send SNS and shadow command sent'
    }

def schedule_shadow_update(washer_id):
    function_name = 'team06_DelayedShadowUpdate'
    delay_seconds = 10
    future_time = datetime.utcnow() + timedelta(seconds=delay_seconds)
    schedule_time = future_time.isoformat(timespec='seconds')
    schedule_name = f"team06_lock-shadow-{washer_id}-{int(time.time())}"

    response = scheduler.create_schedule(
        Name=schedule_name,
        ScheduleExpression=f"at({schedule_time})",
        FlexibleTimeWindow={"Mode": "OFF"},
        Target={
            "Arn": TARGET_LAMBDA_ARN,
            "RoleArn": ROLE_ARN,
            "Input": json.dumps({"washer_id": washer_id, "schedule_name": schedule_name})
        }
    )
    logger.info(f"Scheduled shadow update in 10 seconds: {schedule_name}")
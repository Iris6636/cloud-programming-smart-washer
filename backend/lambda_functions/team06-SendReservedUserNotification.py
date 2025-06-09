import json
import logging
import boto3 
import os

# 設定 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

sns_client = boto3.client('sns')
RESERVATION_SNS_TOPIC_ARN = os.environ.get('SendReservedUserNotification')  

def lambda_handler(event, context):
    logger.info(f"Received event: {event}")

    user_id = event.get('user_id')
    washer_id = event.get('washer_id')
    user_email = event.get('user_email')

    # --- 修改後的參數檢查 ---
    missing_params = []
    if not user_id: # event.get() 在找不到 key 時會回傳 None
        missing_params.append('user_id')
    if not washer_id:
        missing_params.append('washer_id')
    if not user_email:
        missing_params.append('user_email')

    if missing_params:
        # 如果 missing_params 列表不為空，表示有參數缺失
        error_msg = f"事件中缺少必要的參數: {', '.join(missing_params)}。"
        logger.error(error_msg)
        return {
            'statusCode': 400,
            'body': json.dumps({'error': error_msg})
        }
    # --- 參數檢查結束 ---
    subject = f"洗衣機可用通知 (洗衣機編號: {washer_id} )"
    message_body = f"親愛的使用者您好：\n\n您預約的洗衣機 {washer_id} 已可使用。\n系統已為您保留 5 分鐘，請儘快前往使用，謝謝。"


    logger.info(f"Preparing to notify user_id {user_id} for reserving washer_id {washer_id}, target email: {user_email}")

    try:
        response = sns_client.publish(
            TopicArn=RESERVATION_SNS_TOPIC_ARN,
            Message=message_body,
            Subject=subject,
            MessageAttributes={
                'user_email_address': {
                    'DataType': 'String',
                    'StringValue': user_email
                }
            }
        )
        logger.info(f"Message sent to SNS Topic. Message ID: {response.get('MessageId')}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'已嘗試通知預約者 {user_id} (Email: {user_email})。',
                'sns_message_id': response.get('MessageId')
            })
        }
    except Exception as e:
        logger.error(f"發布到 SNS 時發生錯誤: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': f'發送通知失敗: {str(e)}'})
        }
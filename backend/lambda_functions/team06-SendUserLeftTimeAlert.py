import json
import logging
import boto3
import os
from boto3.dynamodb.conditions import Attr

# 設定 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# 初始化 AWS 客戶端
sns_client = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')

# 從環境變數獲取 SNS 主題 ARN 
SNS_TOPIC_ARN = os.environ.get('SendUserLeftTimeAlert')
# UserInfo 表的名稱 (也可以設為環境變數以增加靈活性)
USER_INFO_TABLE_NAME = 'team06-UserInfo'


def send_targeted_sns_notification(washer_id, left_time, user_email_to_notify, user_id_to_greet="使用者"):
    """
    向指定的 user_email 發送關於特定洗衣機剩餘時間的 SNS 通知。
    """
    if not SNS_TOPIC_ARN:
        logger.error("CRITICAL: 環境變數 'SendUserLeftTimeAlert' 未設定。無法發送通知。")
        return False
    
    if not user_email_to_notify:
        logger.warning(f"Washer_id '{washer_id}' 沒有提供 user_email_to_notify，無法發送通知。")
        return False

    #greeting_name = user_id_to_greet if user_id_to_greet else "使用者" # 如果 user_id_to_greet 為 None 或空，則用 "使用者"

    subject = f"洗衣進度通知 (洗衣機編號:{washer_id})"
    if left_time == 0:
        message_body = f"親愛的使用者您好：\n\n您使用的洗衣機已完成洗衣行程！\n請儘快前往取衣，謝謝。"
    elif left_time == 3:
        message_body = f"親愛的使用者您好：\n\n您使用的洗衣機再{left_time}分鐘就完成洗衣行程。\n請準備前往取衣，謝謝。"
    else:
        # 此函數理論上只應在 left_time 為 0 或 3 時被呼叫
        logger.warning(f"send_targeted_sns_notification 收到非預期的 left_time: {left_time} for washer_id: {washer_id}")
        return False

    try:
        response = sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=message_body,
            Subject=subject,
            MessageAttributes={
                'user_email_address': { # 用於 SNS 篩選策略的 Key
                    'DataType': 'String',
                    'StringValue': user_email_to_notify
                }
            }
        )
        logger.info(f"📧 通知已發送給 {user_email_to_notify} (洗衣機: {washer_id}, 剩餘時間: {left_time} 分鐘). Message ID: {response.get('MessageId')}")
        return True
    except Exception as e:
        logger.error(f"❌ 發送 SNS 通知給 {user_email_to_notify} (洗衣機: {washer_id}) 時發生錯誤: {str(e)}")
        return False


def lambda_handler(event, context):
    logger.info(f"Lambda (SendUserLeftTimeAlert) 收到事件: {json.dumps(event)}")

    if not SNS_TOPIC_ARN:
        logger.critical("CRITICAL: 環境變數 'SendUserLeftTimeAlert' 未設定，Lambda 將無法正常工作。")
        return {'status': 'ConfigurationError', 'message': "環境變數 'SendUserLeftTimeAlert' 未設定"}

    successful_notifications = 0
    failed_notifications = 0
    user_table = dynamodb.Table(USER_INFO_TABLE_NAME)

    for record in event.get('Records', []):
        event_name = record.get('eventName')
        
        if event_name in ['INSERT', 'MODIFY']:
            logger.info(f"處理 DynamoDB 事件 ID: {record.get('eventID')}, 事件類型: {event_name}")
            
            new_image = record.get('dynamodb', {}).get('NewImage')
            if not new_image:
                logger.warning(f"記錄 {record.get('eventID')} 中沒有 NewImage，跳過。")
                continue

            washer_id_from_stream = new_image.get('washer_id', {}).get('N')
            left_time_str = new_image.get('time', {}).get('N') # 從 'time' 欄位讀取
            
            if not washer_id_from_stream:
                logger.warning(f"記錄 {record.get('eventID')} 的 NewImage 中缺少 'washer_id'，跳過。")
                continue
            if left_time_str is None:
                logger.warning(f"記錄 {record.get('eventID')} (washer_id: {washer_id_from_stream}) 的 NewImage 中缺少 'time' 欄位，跳過。")
                continue
            
            try:
                left_time_int = int(left_time_str)
            except ValueError:
                logger.error(f"無法將 'time' ({left_time_str}) 轉換為整數 for washer_id '{washer_id_from_stream}'。跳過。")
                continue

            logger.info(f"洗衣機 '{washer_id_from_stream}': 新的 time={left_time_int}")

            # 判斷時間條件
            if left_time_int == 3 or left_time_int == 0:
                logger.info(f"⏰ washer_id '{washer_id_from_stream}' 的剩餘時間為 {left_time_int} 分鐘。準備查找使用中用戶。")
                
                user_email_to_notify = None
                user_id_to_greet = None 
                
                try:
                    # 查找使用中此洗衣機的使用者
                    # ⚠️ 注意：scan 操作對大表可能效率低下且成本高，請考慮優化 (例如使用 GSI 查詢)
                    washer_id_from_stream = int(washer_id_from_stream)

                    result = user_table.scan(
                        FilterExpression=Attr('in_use').eq(washer_id_from_stream)
                    )
                    
                    if result.get('Items'):
                        user_data = result['Items'][0] 
                        user_id_to_greet = user_data.get('user_id') 
                        user_email_to_notify = user_data.get('email')

                        if user_email_to_notify:
                            logger.info(f"找到使用洗衣機 washer_id '{washer_id_from_stream}' 的使用者: ID='{user_id_to_greet}', Email='{user_email_to_notify}'")
                        else:
                            logger.warning(f"找到了使用洗衣機 washer_id '{washer_id_from_stream}' 的使用者 '{user_id_to_greet}'，但其 Email 為空。")
                    else:
                        logger.warning(f"在 UserInfo 表中找不到使用洗衣機 washer_id '{washer_id_from_stream}' 的使用者。")
                
                except Exception as e:
                    logger.error(f"查找 UserInfo for washer_id '{washer_id_from_stream}' 時發生錯誤: {str(e)}")
                
                # 根據是否找到 Email 來發送通知
                if user_email_to_notify:
                    logger.info(f"準備發送通知給 Email '{user_email_to_notify}'。")
                    if send_targeted_sns_notification(washer_id_from_stream, left_time_int, user_email_to_notify, user_id_to_greet):
                        successful_notifications += 1
                    else:
                        failed_notifications += 1
                else:
                    logger.info(f"洗衣機 '{washer_id_from_stream}' (剩餘時間: {left_time_int}) 雖然滿足時間條件，但未找到有效的 Email，不發送通知。")
                    # 即使未找到Email，也可以考慮將 failed_notifications 增加，視為一次「應通知但失敗」的嘗試
                    # failed_notifications += 1 
            else: # left_time 不是 3 或 0
                logger.info(f"洗衣機 '{washer_id_from_stream}' (剩餘時間: {left_time_int}) 不滿足通知時間條件。")
        
        elif event_name == 'REMOVE':
            logger.info(f"記錄 {record.get('eventID')} 是 REMOVE 事件，跳過通知處理。")
        else:
            logger.warning(f"未知的事件類型 '{event_name}' for record {record.get('eventID')}，跳過。")

    logger.info(f"Lambda (SendUserLeftTimeAlert) 處理完成。成功發送通知: {successful_notifications}, 發送失敗: {failed_notifications}")
    return {
        'statusCode': 200,
        'body': json.dumps(f'Processed {len(event.get("Records", []))} records. Successful notifications: {successful_notifications}, Failed: {failed_notifications}')
    }

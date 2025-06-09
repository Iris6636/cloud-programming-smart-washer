import boto3
import time
import logging
from datetime import datetime
import json #用於標準化回傳

# 設定 logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# 設定 AWS 客戶端
rekognition = boto3.client('rekognition')
s3 = boto3.client('s3') 
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('team06-WasherStatus')  # 確認這是正確的 DynamoDB 表名 #to_be_updated

def update_left_time_in_db(washer_id, time_str_from_rekognition):
    """
    將辨識到的時間字串轉換為整數並更新到 DynamoDB。
    回傳更新後的整數時間，如果更新失敗則回傳 None。
    """
    try:
        new_time_int = int(time_str_from_rekognition)
        
        table.update_item(
            Key={
                'washer_id': washer_id
            },
            UpdateExpression="SET #t = :lt",
            ExpressionAttributeNames={
                '#t': 'time'
            }, 
            ExpressionAttributeValues={ 
                ':lt': new_time_int 
            }, 
            ReturnValues="UPDATED_NEW" 
        )

        logger.info(f"✅ DynamoDB: 'time' for washer_id '{washer_id}' successfully updated to {new_time_int}.")
        # return new_time_int # 這裡應該還有 return 和 except 區塊
        return new_time_int
    except ValueError:
        logger.error(f"[DDB_UPDATE_FAIL] Value Error: Cannot convert '{time_str_from_rekognition}' to an integer for washer_id '{washer_id}'.")
        return None
    except Exception as e:
        logger.error(f"[DDB_UPDATE_FAIL] Error updating DynamoDB for washer_id '{washer_id}': {str(e)}")
        return None

def lambda_handler(event, context):
    #time.sleep(3)  # 等待 4 秒確保圖片已寫完

    try:
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        logger.info(f"Lambda: Processing image '{key}' from bucket '{bucket}'.")

        # 呼叫 Rekognition 做文字辨識
        response_rekognition = rekognition.detect_text(
            Image={
                'S3Object': {
                    'Bucket': bucket,
                    'Name': key
                }
            }
        )

        texts = response_rekognition['TextDetections']
        # 抓出所有是 LINE 類型、且內容是數字的項目
        detected_numbers_str_list = [t['DetectedText'] for t in texts if t['Type'] == 'LINE' and t['DetectedText'].isdigit()]
        
        logger.info(f"Lambda: Rekognition detected numbers: {detected_numbers_str_list}")

        if detected_numbers_str_list:
            # 取第一個辨識到的數字作為剩餘時間
            time_from_image_str = detected_numbers_str_list[0]
            
            washer_id = int('1')  # 暫時寫死，之後再調整成實際的id作回傳使用 #to_be_updated
            logger.info(f"Lambda: Determined washer_id: '{washer_id}' for image '{key}'.")

            # 更新 DynamoDB
            updated_time = update_left_time_in_db(washer_id, time_from_image_str)
            
            if updated_time is not None:
                # DynamoDB 更新成功，Lambda的主要任務完成
                return {
                    'statusCode': 200,
                    'body': json.dumps({
                        'message': f"Image processed. Washer '{washer_id}' time updated to {updated_time}.",
                        'washer_id': washer_id,
                        'new_time': updated_time,
                        'detected_numbers': detected_numbers_str_list
                    })
                }
            else:
                # DynamoDB 更新失敗
                return {
                    'statusCode': 500,
                    'body': json.dumps({
                        'error': f"Failed to update DynamoDB for washer_id '{washer_id}'.",
                        'image_key': key,
                        'detected_numbers': detected_numbers_str_list
                    })
                }
        else:
            logger.warning(f"[REKOGNITION_FAIL] No numbers detected in image '{key}'. DynamoDB not updated.")
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': "No numbers detected in the image.",
                    'image_key': key,
                    'detected_numbers': detected_numbers_str_list
                })
            }

    except Exception as e:
        logger.error(f"[LAMBDA_EXCEPTION] Unhandled error processing S3 event: {str(e)}")

        return {
            'statusCode': 500,
            'body': json.dumps({'error': f"Unhandled error in Lambda: {str(e)}"})
        }
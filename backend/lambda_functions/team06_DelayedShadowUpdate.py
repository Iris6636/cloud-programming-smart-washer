import boto3
import json
import logging

iot_data = boto3.client('iot-data', region_name='us-east-1')
scheduler = boto3.client('scheduler', region_name='us-east-1')
thing_name = "team06_IoT"
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Triggered by EventBridge Scheduler with event: {json.dumps(event)}")
    
    washer_id = event.get("washer_id")
    shadow_payload = {
        "state": {
            "desired": {
                "door_locked": True
            }
        }
    }

    # 嘗試刪除觸發本次執行的 schedule
    try:
        schedule_name = event.get("schedule_name")
        if schedule_name:
            scheduler.delete_schedule(Name=schedule_name)
            logger.info(f"Deleted schedule: {schedule_name}")
        else:
            logger.warning("No schedule_name provided in event, skipping deletion.")
        
    except Exception as e:
        logger.error(f"Failed to delete schedule: {e}")


    try:
        iot_data.update_thing_shadow(
            thingName=thing_name,
            payload=json.dumps(shadow_payload)
        )
        logger.info(f"Device shadow updated for washer_id {washer_id}")
        return {'statusCode': 200, 'body': 'Shadow updated'}
    except Exception as e:
        logger.error(f"Failed to update shadow: {e}")
        return {'statusCode': 500, 'body': 'Shadow update failed'}

    return {
        'statusCode': 200,
        'body': 'Shadow updated and schedule deleted'
    }

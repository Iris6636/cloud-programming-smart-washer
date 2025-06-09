import boto3
import time
import json
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
iot_data = boto3.client('iot-data', region_name='us-east-1')
thing_name = "team06_IoT"
scheduler = boto3.client('scheduler')

def lambda_handler(event, context):
    print(f"Event received:\n{json.dumps(event, indent=2)}")
    washer_id = event["washer_id"]
    expire_at = event["expire_at"]
    now = int(time.time())
    print("now: ", now)

    # 刪除對應的 scheduler
    schedule_name = f"team06_expire-check-washer-{washer_id}-{expire_at}"
    try:
        scheduler.delete_schedule(Name=schedule_name)
        print(f"Deleted schedule: {schedule_name}")
    except Exception as e:
        print(f"Failed to delete schedule {schedule_name}: {e}")


    table = dynamodb.Table("team06-WasherStatus")
    response = table.get_item(Key={"washer_id": washer_id})

    item = response.get("Item")
    if not item:
        return {"status": "Washer not found"}

    if item.get("in_use") or not item.get("reserved"):
        print("Washer in use or not reserved anymore")
        return

    if now < expire_at:
        print("Not expired yet")
        return

    # 清除預約
    table.update_item(
        Key={"washer_id": washer_id},
        UpdateExpression="REMOVE expire_at SET reserved = :r",
        ExpressionAttributeValues={":r": False}
    )

    # 找到該使用者，刪除 reserved 欄位
    user_table = dynamodb.Table("team06-UserInfo")
    user_response = user_table.scan(
        FilterExpression="reserved = :w",
        ExpressionAttributeValues={":w": washer_id}
    )
    for user in user_response["Items"]:
        user_table.update_item(
            Key={"user_id": user["user_id"]},
            UpdateExpression="REMOVE reserved"
        )

    # 發送 desired 狀態到 Device Shadow
    shadow_payload = {
        "state": {
            "desired": {
                "door_locked": False,
                "unlock_reason": "reserve_related"
            }
        }
    }

    iot_data.update_thing_shadow(
        thingName=thing_name,
        payload=json.dumps(shadow_payload)
    )

    print("Reservation expired and cleared")

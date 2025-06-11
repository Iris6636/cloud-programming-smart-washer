import time
import json
import base64
import traceback
import threading
import sys
import RPi.GPIO as GPIO
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient, AWSIoTMQTTShadowClient
from picamera2 import Picamera2

# ---------------------- GPIO / Motor Config ----------------------
GPIO.setmode(GPIO.BCM)
LOCK_PIN_1 = 15
MOTOR_PIN_2 = 16
GPIO.setup(LOCK_PIN_1, GPIO.OUT)
GPIO.setup(MOTOR_PIN_2, GPIO.OUT)

# ---------------------- 7-Segment LED Setup ----------------------
digit_1_pins = [1, 2, 3, 4, 5, 6, 7]     # Tens digit
digit_2_pins = [8, 9, 10, 11, 12, 13, 14]  # Units digit

for pin in digit_1_pins + digit_2_pins:
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)

num_patterns = {
    0: (1, 1, 1, 1, 1, 1, 0),
    1: (0, 1, 1, 0, 0, 0, 0),
    2: (1, 1, 0, 1, 1, 0, 1),
    3: (1, 1, 1, 1, 0, 0, 1),
    4: (0, 1, 1, 0, 0, 1, 1),
    5: (1, 0, 1, 1, 0, 1, 1),
    6: (1, 0, 1, 1, 1, 1, 1),
    7: (1, 1, 1, 0, 0, 0, 0),
    8: (1, 1, 1, 1, 1, 1, 1),
    9: (1, 1, 1, 1, 0, 1, 1)
}

def display_digit(digit_pins, number):
    pattern = num_patterns.get(number, (0, 0, 0, 0, 0, 0, 0))
    for i in range(7):
        GPIO.output(digit_pins[i], pattern[i])

def display_number(number):
    tens = number // 10
    units = number % 10
    display_digit(digit_1_pins, tens)
    display_digit(digit_2_pins, units)

# ---------------------- Camera Setup ----------------------------
camera_lock = threading.Lock()
picam2 = Picamera2()
picam2.configure(picam2.create_still_configuration(main={"size": (640, 480)}))
picam2.start()
time.sleep(2)
print("Camera initialized")

# ---------------------- MQTT & Shadow Setup ---------------------
THING_NAME = "team06_IoT"
ENDPOINT = "a2l2r8z087kz73-ats.iot.us-east-1.amazonaws.com"
ROOT_CA = "/home/team6/Downloads/Final/AmazonRootCA1_RSA.pem"
CERT = "/home/team6/Downloads/Final/certificate.pem"
KEY = "/home/team6/Downloads/Final/private.pem.key"
MQTT_TOPIC = "device/camera/image"



mqtt_client = AWSIoTMQTTClient("WasherMQTT")
mqtt_client.configureEndpoint(ENDPOINT, 8883)
mqtt_client.configureCredentials(ROOT_CA, KEY, CERT)
mqtt_client.connect()

shadow_client = AWSIoTMQTTShadowClient("WasherShadow")
shadow_client.configureEndpoint(ENDPOINT, 8883)
shadow_client.configureCredentials(ROOT_CA, KEY, CERT)
shadow_client.connect()
device_shadow = shadow_client.createShadowHandlerWithName(THING_NAME, True)

# ---------------------- Washer State ----------------------------
vibration_state = False
motor_running = False
washer_id = 1
door_locked_state = False
capture_requested_state = False
unlock_reason_state = None


# ---------------------- Motor & Lock Control ---------------------------
def set_motor(on: bool):
    GPIO.output(MOTOR_PIN_2, GPIO.HIGH if on else GPIO.LOW)
    print(f"[MOTOR] {'Started' if on else 'Stopped'}")


def set_lock_state(locked: bool):
    GPIO.output(LOCK_PIN_1, GPIO.HIGH if locked else GPIO.LOW)
    print(f"[LOCK] Washer door {'locked' if locked else 'unlocked'}")


# ---------------------- Camera Capture --------------------------
photo_thread = None
photo_thread_running = False

def photo_loop():
    global photo_thread_running
    while photo_thread_running:
        take_photo()
        time.sleep(2.5)
        
def take_photo():
    print("[PHOTO] Taking photo now...")
    if not camera_lock.acquire(blocking=False):
        print("[PHOTO] Camera busy, skipping")
        return
    try:
        timestamp = int(time.time())
        filename = f"/tmp/NTHU-{timestamp}.jpg"
        picam2.capture_file(filename)
        with open(filename, "rb") as f:
            encoded = base64.b64encode(f.read()).decode('utf-8')
        payload = {"filename": f"NTHU-{timestamp}.jpg", "image_data": encoded}
        mqtt_client.publish(MQTT_TOPIC, json.dumps(payload), 1)
        print(f"[PHOTO] Published {filename} to {MQTT_TOPIC}")
    except Exception as e:
        print(f"[ERROR] Camera error: {e}")
        traceback.print_exc()
    finally:
        camera_lock.release()

# ---------------------- Shadow Report --------------------------
last_reported_state = {}

def report_shadow(clear_desired_fields=None):
    global last_reported_state

    current_state = {
        "washer_id": washer_id,
        "vibration_detected": vibration_state,
        "door_locked": door_locked_state,
        "capture_requested": capture_requested_state,
        "unlock_reason": unlock_reason_state
    }

    if current_state == last_reported_state and not clear_desired_fields:
        print("[SHADOW] No changes, skip reporting")
        return

    last_reported_state = current_state.copy()
    desired_clears = {key: None for key in (clear_desired_fields or [])}

    payload = {
        "state": {
            "reported": current_state,
            "desired": desired_clears
        }
    }
    
    device_shadow.shadowUpdate(json.dumps(payload), None, 5)
    print("[SHADOW] State reported", json.dumps(payload, indent=2))

# ---------------------- Delta Callback -------------------------
def shadow_delta_callback(payload, responseStatus, token):
    global door_locked_state, capture_requested_state, unlock_reason_state
    global photo_thread, photo_thread_running
    print("[DELTA] Received:", payload)
    delta = json.loads(payload).get("state", {})
    
    cleared_fields = []
    
    if "door_locked" in delta:
        door_locked_state = delta["door_locked"]
        set_lock_state(door_locked_state)
        cleared_fields.append("door_locked")
        
    if "capture_requested" in delta:
        if delta["capture_requested"]:
            if not photo_thread_running:
                print("[PHOTO] Starting photo loop...")
                capture_requested_state = True
                photo_thread_running = True
                photo_thread = threading.Thread(target=photo_loop)
                photo_thread.start()
        else:
            if photo_thread_running:
                print("[PHOTO] Stopping photo loop...")
                take_photo()
                capture_requested_state = False
                photo_thread_running = False
                if photo_thread:
                    photo_thread.join()
                    photo_thread = None
        cleared_fields.append("capture_requested")
        
    if "unlock_reason" in delta:
        unlock_reason_state = delta["unlock_reason"]
        cleared_fields.append("unlock_reason")
        
    report_shadow(clear_desired_fields=cleared_fields)

device_shadow.shadowRegisterDeltaCallback(shadow_delta_callback)

# ---------------------- Main Execution --------------------------
try:
    print("Washer simulator starting. Countdown begins...")
    for i in range(10, 0, -1):
        motor_running = True
        vibration_state = True
        set_motor(True)
        display_number(i)  # Show countdown number on LED
        print(f"[TIMER] Washing... {i} seconds left")
        report_shadow()
        #take_photo()
        time.sleep(5)

    motor_running = False
    vibration_state = False
    set_motor(False)
    display_number(0)  # Display 00
    print("[TIMER] Washing completed.")
    report_shadow()
    print("[STATUS] Waiting for Device Shadow updates (lock/photo)...")
    while True:
        time.sleep(5)

except KeyboardInterrupt:
    print("Interrupted")

finally:
    for pin in digit_1_pins + digit_2_pins:
        GPIO.output(pin, GPIO.LOW)
    GPIO.cleanup()
    print("GPIO cleanup done")
    sys.exit(0)

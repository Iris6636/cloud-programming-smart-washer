import RPi.GPIO as GPIO
import time

# --- GPIO Setup ---
GPIO.setmode(GPIO.BCM)

# Set GPIO 15 and 16 as output pins
gpio_pin_15 = 15
gpio_pin_16 = 16
GPIO.setup(gpio_pin_15, GPIO.OUT)
GPIO.setup(gpio_pin_16, GPIO.OUT)

# Set GPIO 17 as input pin for SW-420 sensor
vibration_pin = 17
GPIO.setup(vibration_pin, GPIO.IN)

# --- Control GPIO Voltage ---
def set_gpio(pin, state):
    """Set the voltage level of the specified GPIO pin."""
    if state.upper() == "HIGH":
        GPIO.output(pin, GPIO.HIGH)
        print(f"GPIO {pin} set to HIGH")
    elif state.upper() == "LOW":
        GPIO.output(pin, GPIO.LOW)
        print(f"GPIO {pin} set to LOW")
    else:
        print(f"Error: Invalid state '{state}'. Please use 'HIGH' or 'LOW'.")

# --- Main Program ---
try:
    print("Starting GPIO control and SW-420 monitoring... Press Ctrl+C to stop.")
    while True:
        # Read vibration sensor value
        vibration = GPIO.input(vibration_pin)
        if vibration == GPIO.LOW:
            print("??  Vibration detected! (GPIO 17 is LOW)")
        else:
            print("No vibration. (GPIO 17 is HIGH)")

        # Control GPIO 15 and 16 regularly
        set_gpio(gpio_pin_15, "HIGH")
        set_gpio(gpio_pin_16, "HIGH")
        time.sleep(5)

        set_gpio(gpio_pin_15, "LOW")
        set_gpio(gpio_pin_16, "LOW")
        time.sleep(5)

except KeyboardInterrupt:
    print("\nUser interruption detected (Ctrl+C)...")

finally:
    print("Cleaning up GPIO...")
    GPIO.cleanup()
    print("GPIO cleanup complete.")

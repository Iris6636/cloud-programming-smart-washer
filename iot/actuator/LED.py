import RPi.GPIO as GPIO
import time
import sys

# --- GPIO Configuration (modify according to your wiring) ---
# Segment control pins for the units digit (a, b, c, d, e, f, g)
digit_1_pins = [1, 2, 3, 4, 5, 6, 7]  # Example: update with your actual wiring
# Segment control pins for the tens digit (a, b, c, d, e, f, g)
digit_2_pins = [8, 9, 10, 11, 12, 13, 14]  # Example: update with your actual wiring

# --- Set GPIO Mode ---
GPIO.setmode(GPIO.BCM)

# Set all segment pins as output and initialize to LOW (segments off)
for pin in digit_1_pins:
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)
for pin in digit_2_pins:
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)

# --- Digit segment patterns (Common Cathode: HIGH = ON, LOW = OFF) ---
#                a, b, c, d, e, f, g
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

# --- Display a single digit ---
def display_digit(digit_pins, number):
    """Set segment pattern for a single 7-segment display (0-9)."""
    if number < 0 or number > 9:
        pattern = (0, 0, 0, 0, 0, 0, 0)
        print(f"Display error: Number {number} is out of range (0?9)")
    else:
        pattern = num_patterns.get(number)

    for i in range(7):
        GPIO.output(digit_pins[i], pattern[i])

# --- Display a two-digit number ---
def display_number(number):
    """Display a 0?99 number on two 7-segment displays."""
    if 0 <= number <= 99:
        tens = number // 10
        units = number % 10
        display_digit(digit_1_pins, tens)   # Display tens digit
        display_digit(digit_2_pins, units)  # Display units digit
    else:
        print(f"Display error: Number {number} is out of range (0?99)")

# --- Main Program ---
try:
    start_number = 90  # Set the starting number for countdown (modifiable)
    current_number = start_number

    print(f"Starting countdown from {start_number}... Press Ctrl+C to stop.")
    while current_number >= 0:
        print(f"Displaying: {current_number:02d}")  # Format as two digits
        display_number(current_number)
        time.sleep(1)  # Wait for 1 second
        current_number -= 1

    print("Countdown complete!")

except KeyboardInterrupt:
    print("\nUser interruption detected (Ctrl+C)...")

finally:
    # Always clean up GPIO settings before exiting
    print("Cleaning up GPIO...")
    for pin in digit_1_pins:
        try:
            GPIO.output(pin, GPIO.LOW)
        except RuntimeError:
            pass
    for pin in digit_2_pins:
        try:
            GPIO.output(pin, GPIO.LOW)
        except RuntimeError:
            pass
    GPIO.cleanup()
    print("GPIO cleanup complete.")
    sys.exit(0)

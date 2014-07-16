#include <SPI.h>
#include <ble.h>
#include <Servo.h>

#define LED_LOCK_PIN      5
#define LED_UNLOCK_PIN    6
#define SERVO_PIN         7

/**
 * Reference to our servo instance
 */
Servo lockServo;

/**
 * Boolean reference to whether the door is locked or not
 */
boolean isLocked = false;

/**
 * Applicaiton setup
 */
void setup() {

    Serial.begin(9600);
    Serial.println("Arduino door lock online now...");
  
    SPI.setDataMode(SPI_MODE0);
    SPI.setBitOrder(LSBFIRST);
    SPI.setClockDivider(SPI_CLOCK_DIV16);
    SPI.begin();

    ble_begin();

    // assign pins
    pinMode(LED_LOCK_PIN, OUTPUT);
    pinMode(LED_UNLOCK_PIN, OUTPUT);
    lockServo.attach(SERVO_PIN);
}

/**
 * Application functionality
 */
void loop() {

    // If data is ready
    while(ble_available()) {
    
        // read out command and data
        byte data0 = ble_read();
        byte data1 = ble_read();

        

        // lock or unlock the foor
        if (data0 == 0x00) {
            if (data1 == 0x00) {
                lockDoor();
            } else {
                unlockDoor();
            } 
        }

        // @TODO: add functionality here that will respond to a request of whether 
        // the door is unlocked or not and will respond to whoever's asking

        // if we get diconnected then turn off all LED
        if (!ble_connected()) {
            resetLED();
        }

    }

    // Allow BLE Shield to send/receive data
    ble_do_events();  
}

/**
 * Locking the door turns the locked LED HIGH, the unlocked LED LOW and sets
 * the servo to 0 degrees.
 */
void lockDoor() {
    isLocked = true;
    digitalWrite(LED_LOCK_PIN, HIGH);
    digitalWrite(LED_UNLOCK_PIN, LOW);
    lockServo.write(90);
}

/**
 * Unlocking the door turns the locked LED LOW, the unlocked LED HIGH and sets
 * the servo to 90 degrees.
 */
void unlockDoor() {
    isLocked = false;
    digitalWrite(LED_LOCK_PIN, LOW);
    digitalWrite(LED_UNLOCK_PIN, HIGH);
    lockServo.write(0);
}

/**
 * Sets both LED PINS to LOW
 */
void resetLED() {
    digitalWrite(LED_LOCK_PIN, LOW);
    digitalWrite(LED_UNLOCK_PIN, LOW);
}

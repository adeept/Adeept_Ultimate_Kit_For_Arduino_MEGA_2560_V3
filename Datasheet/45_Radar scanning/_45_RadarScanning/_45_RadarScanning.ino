/***********************************************************
File name:  _45_RadarScanning.ino
Description:  

Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
#include <Servo.h>

Servo ultrasonicServo;            // define servo to control turning of ultrasonic sensor
int ultrasonicPin = 6;            // define pin for signal line of the last servo

int trigPin = 2;                  // define Trig pin for ultrasonic ranging module
int echoPin = 3;                  // define Echo pin for ultrasonic ranging module

float maxDistance = 200;          // define the range(cm) for ultrasonic ranging module, Maximum sensor distance is rated at 400-500cm.
float soundVelocity = 340;        // Sound velocity = 340 m/s
float rangingTimeOut = 2 * maxDistance / 100 / soundVelocity * 1000000; // define the timeout(ms) for ultrasonic ranging module
int currentDistance = 0;

void setup() {
Serial.begin(9600);
  ultrasonicServo.attach(ultrasonicPin);  // attaches the servo on ultrasonicPin to the servo object
  pinMode(trigPin, OUTPUT); // set trigPin to output mode
  pinMode(echoPin, INPUT);  // set echoPin to input mode
}
void loop()
{
      // rotates the servo motor from 15 to 165 degrees
      for(int i=0;i<=180;i++){  
        ultrasonicServo.write(i);
        currentDistance = getDistance();
        delay(50);
        Serial.print(i); // Sends the current degree into the Serial Port
        Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
        Serial.print(currentDistance); // Sends the distance value into the Serial Port
        Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      }
      // Repeats the previous lines from 165 to 15 degrees
      for(int i=180;i>0;i--){  
        ultrasonicServo.write(i);
        currentDistance = getDistance();
        delay(50);
        Serial.print(i); // Sends the current degree into the Serial Port
        Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
        Serial.print(currentDistance); // Sends the distance value into the Serial Port
        Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      }
}
float getDistance() {
  unsigned long pingTime; // save the high level time returned by ultrasonic ranging module
  float distance;         // save the distance away from obstacle

  // set the trigPin output 10us high level to make the ultrasonic ranging module start to measure
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // get the high level time returned by ultrasonic ranging module
  pingTime = pulseIn(echoPin, HIGH, rangingTimeOut);

  if (pingTime != 0) {  // if the measure is not overtime
    distance = pingTime * soundVelocity / 2 / 10000;  // calculate the obstacle distance(cm) according to the time of high level returned
    return distance;    // return distance(cm)
  }
  else                  // if the measure is overtime
    return maxDistance; // returns the maximum distance(cm)
}

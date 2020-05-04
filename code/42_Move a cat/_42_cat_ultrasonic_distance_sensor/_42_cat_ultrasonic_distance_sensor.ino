/***********************************************************
File name:   42_cat_ultrasonic_distance_sensor.ino
Description: Arduino and processing interactive
             We use the ultrasonic distance sensor to collect the distance information
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
const int pingPin = 5; 
const int trigPin  = 7; // pin connected to 

void setup() 
{
   Serial.begin(9600);   // opens serial port, sets data rate to 9600 bps
   pinMode(pingPin, INPUT); 
   pinMode(trigPin, OUTPUT);
} 

void loop() 
{ 
   int cm = ping(pingPin); 
   Serial.write(cm); //send data to the serial monitor
//   Serial.println(cm); //send data to the serial monitor
   delay(100);
}
     
int ping(int pingPin) 
{ 
   // establish variables for duration of the ping, 
   // and the distance result in inches and centimeters: 
   long duration, cm; 
   // The PING))) is triggered by a HIGH pulse of 2 or more microseconds. 
   // Give a short LOW pulse beforehand to ensure a clean HIGH pulse: 
   pinMode(trigPin, OUTPUT); 
   digitalWrite(trigPin, LOW); 
   delayMicroseconds(2); 
   digitalWrite(trigPin, HIGH); 
   delayMicroseconds(5); 
   digitalWrite(trigPin, LOW); 

   pinMode(pingPin, INPUT); 
   duration = pulseIn(pingPin, HIGH); 

   // convert the time into a distance 
   cm = microsecondsToCentimeters(duration); 
   return cm ; 
} 

long microsecondsToCentimeters(long microseconds) 
{ 
   // The speed of sound is 340 m/s or 29 microseconds per centimeter. 
   // The ping travels out and back, so to find the distance of the 
   // object we take half of the distance travelled. 
   return microseconds / 29 / 2; 
} 

        
        
        
        
      

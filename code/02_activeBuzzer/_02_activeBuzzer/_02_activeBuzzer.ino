/***********************************************************
File name: 02_activeBuzzer.ino
Description: Arduino 2560 Continuous beeps control buzzer.
Website: www.adeept.com
E-mail: support@adeept.com
Author: Tom
Date: 2015/12/27 
***********************************************************/
int buzzerPin=8; //definition digital 8 pins as pin to control the buzzer
void setup()
{
    pinMode(buzzerPin,OUTPUT); //Set digital 8 port mode, the OUTPUT for the output
}
void loop()
{  
    digitalWrite(buzzerPin,HIGH); //Set PIN 8 feet as HIGH = 5 v 
    delay(2000);                   //Set the delay time，2000ms 
    digitalWrite(buzzerPin,LOW);  //Set PIN 8 feet for LOW = 0 v 
    delay(2000);                   //Set the delay time，2000ms
}

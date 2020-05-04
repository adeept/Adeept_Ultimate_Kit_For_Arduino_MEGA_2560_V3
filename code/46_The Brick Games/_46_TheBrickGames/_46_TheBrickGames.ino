/***********************************************************
File name:   46_The Brick Games.ino
Description: Arduino and processing interactive
             Two buttons control the Brick Game
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
const int rightPin = 7; // Digital pin 7 connected to right button 
const int leftPin  = 8; // Digital pin 8 connected to left button 

void setup() 
{
   Serial.begin(9600); 
   pinMode(rightPin, INPUT_PULLUP); //Set the rightPin to INPUT_PULLUP mode 
   pinMode(leftPin, INPUT_PULLUP);  //Set the leftPin to INPUT_PULLUP mode 
} 

void loop() 
{ 
  int rval = digitalRead(rightPin) ; //Read the right button information
  int lval = digitalRead(leftPin) ;  //Read the left button information
  
  Serial.print(rval);//Dend rval value
  Serial.print(','); 
  Serial.print(lval);//Dend lval value
  Serial.println(','); 
  delay(10);
}
     

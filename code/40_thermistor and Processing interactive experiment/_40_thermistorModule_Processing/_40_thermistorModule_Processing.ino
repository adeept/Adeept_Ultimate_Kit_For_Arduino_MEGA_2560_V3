/***********************************************************
File name: 40_thermistor.ino
Description: The information which a thermistor collects 
             temperature is displayed on the LCD1602.
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
int thermistorPin = 0;           // thermistor connected to analog pin 3
void setup()
{
  Serial.begin(9600);//opens serial port, sets data rate to 9600 bps
}

void loop() 
{
  int temp;
   float a = analogRead(thermistorPin);
  //the calculating formula of temperature
  float resistor = (1023.0*10000)/a-10000;
  temp = (3435.0/(log(resistor/10000)+(3435.0/(273.15+25)))) - 273.15;
  Serial.write(temp);//send data to the serial monitor
  delay(500);
}

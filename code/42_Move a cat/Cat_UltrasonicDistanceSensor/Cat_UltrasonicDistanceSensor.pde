/***********************************************************
File name:   Cat_UltrasonicDistanceSensor.pde
Description: Arduino and processing interactive
             We use a cat and a robot to show the distance information
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
import processing.serial.*;//Load the serial library

Serial myPort;
PImage picture1;
PImage picture2;
PImage picture3;
PFont font;//Create font Variables
int val=0;
int distance;
 
void setup(){
  size(1000,400);//Defines the dimension of the display window in units of pixels
  background(0);//sets the color used for the background of the Processing window
  picture1 = loadImage("robot.png");
  picture2 = loadImage("Cat.png");
  picture3 = loadImage("LOGO11.png");
  // Open the serial port and set the baud rate to 9600
  // This experiment arduino board is connected to COM26, here please
  myPort = new Serial(this,"COM26",9600);
  noSmooth();
  font = createFont("Arial",48,true);//Loading system font
}

void draw(){
  if(myPort.available() > 0){
    distance = myPort.read();//Received Arduino UNO data
   //if(2*distance+3>val){
   //  val=val+3;
   //}else if(2*distance+3<val){
   //   val=val-3;
   //}else{
   //   val=distance;
   //}
   }
    background(0);
    imageMode(CENTER);
    image(picture1,84,height/2);//Display the 'robot' picture
    image(picture2,2*distance+300,height/2);//Display the 'Cat' picture
    image(picture3,950,350);//Display the 'LOGO11' picture
    fill(255,0,0);//Set the fill color
    textFont(font,30);//Set the font size
    text("The current distance is "+"\n"+distance+" cm",10,40);
}

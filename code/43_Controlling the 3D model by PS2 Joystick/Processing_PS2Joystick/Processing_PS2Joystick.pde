/***************************************************************
File name:   Processing_PS2Joystick.pde
Description: Arduino and processing interactive
             The Joystiak data which Arduino collected send 
             the processing software to display.
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
*****************************************************************/ 
import processing.opengl.*; //Transferred to the 3D library
import processing.serial.*; //Transferred to the serial library
  
Serial myPort;//Create Serial objects myPort 
PFont font;//Create font Variables
int Rw[] = new int[3];
byte inBuffer[] = new byte[100];
PImage img;

void setup() { 
  // set the canvas size is 600 x 600
  size(600,600,OPENGL); //Set the size of 3D canvas
  
  // Open the serial port and set the baud rate to 9600
  // This experiment arduino board is connected to COM26, here please
  // adjust according to actual situation.
  myPort = new Serial(this,"COM26",9600);
  noSmooth();
  font = createFont("Arial",48,true);//Loading system font
  img = loadImage("LOGO11.png");
}

void draw() { 
  background(0);//Set Background Color
  image(img,450,450);
  lights();//Open lights
  readSensors();//Read 2-Axis value
  fill(255,0,0);//Set the fill color
  textFont(font,30);//Set the font size
  text("ANGLE :\n"+"xval:"+Rw[0]+"\n"+"yval:"+Rw[1]+"\n"+"swval:"+Rw[2],50,50);//Read the value displayed
  if(Rw[2]==1){
    fill(255,0,255);//Set the fill color
  }else{
    fill(0,255,255);//Set the fill color
  }
 
  translate(-Rw[1]/4+300,-Rw[0]/4+300,0);//Settings Transfer Coordinates
  box(50,50,250);//Draw a box 300 * 300 * 40
} 
void  readSensors(){
  if(myPort.available()>0){
     if(myPort.readBytesUntil(10,inBuffer)>0){//Read to determine whether the wrap 10BYTE
      String inputString = new String(inBuffer);
      String inputStringArr[] = split(inputString,',');//Data ',' Split
      Rw[0] = int(inputStringArr[0]);//Read the X value
      Rw[1] = int(inputStringArr[1]);//Read the y value
      Rw[2] = int(inputStringArr[2]);
      Rw[0] = 515 - Rw[0];//Rocker midpoint value 515 into 0
      Rw[1] = Rw[1] - 515;//Converted to negative (rocker line out)
    }
  }
}

/***********************************************************
File name:   Snake_Game_Processing_Button.pde
Description: Arduino and processing interactive
             Button controls Snake Game
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
***********************************************************/
import processing.serial.*; 
import processing.sound.*; 
SoundFile file;
Serial myPort;//Create Serial objects myPort 
int Rw[] = new int[2];
byte inBuffer[] = new byte[100];
PImage img;

int num = 60;
float mx[] = new float[num];
float my[] = new float[num];
int windowWidth = 800;
int windowHeight = 600;
int r = 100;
int x0 = windowWidth/2;
int y0 = windowHeight/2;
float theta;
float speed = 0.04;
int direction = 1;
int ballx, bally;
float ballr = 30;
int ballrMax = 40;
int ballrMin = 20;
float largerOrSmaller = -.3;
PFont fontA;
int score;
int limitedSec = 60*3;
int sec;
float m;// = millis();//time consuming

void setup() {
  size(800, 600);
  file = new SoundFile(this,"Snake Game.mp3");
  file.loop(); 
  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
  // Set the font and its size (in units of pixels)
  textFont(fontA, 16);
  
  smooth();
  noStroke();
  fill(255, 153); 
  frameRate(100);
  ballx=(int)random(windowWidth);
  bally=(int)random(windowHeight);
  // Open the serial port and set the baud rate to 9600
  // This experiment arduino board is connected to COM26, here please
  // adjust according to actual situation.
  myPort = new Serial(this,"COM26",9600);
  img = loadImage("LOGO11.png");
}

void draw() {
   
  background(83,67,68); 
  
  image(img,650,450);

 // fill(249,232,92);
  fill(255,255,0);
  ellipse(ballx,bally,ballr,ballr);
  ballr += largerOrSmaller;
  if((ballr>ballrMax)|(ballr<ballrMin))largerOrSmaller *= -1;
  
  // Cycle through the array, using a different entry on each frame. 
  // Using modulo (%) like this is faster than moving all the values over.
  println(frameRate);//dist(x0,y0,ballx,bally));
  int which = frameCount % num;
  mx[which] = x0 + r * cos(theta);
  my[which] = y0 + r * sin(theta);
  buttonRandL();
  if (direction == 1)theta+=speed;
  else theta -=speed;
  
  mx[which]=(mx[which]<0)?((mx[which]%windowWidth)+windowWidth):(mx[which]%windowWidth);
  my[which]=(my[which]<0)?((my[which]%windowHeight)+windowHeight):(my[which]%windowHeight);
  
  if(dist(mx[which],my[which],ballx,bally)<(ballrMin+num/4)){
    ballx=(int)random(windowWidth);
    bally=(int)random(windowHeight);
    speed += 0.001;
    score++; 
  }
  
  fill(0,0,255);
  for (int i = 0; i < num; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % num;
    ellipse((mx[index]<0)?((mx[index]%windowWidth)+windowWidth):(mx[index]%windowWidth), (my[index]<0)?((my[index]%windowHeight)+windowHeight):(my[index]%windowHeight), i/3, i/3);
  }
  
  if(x0>1000)x0=x0%windowWidth;
  if(x0<-1000)x0=x0%windowWidth+windowWidth;
  if(y0>1000)y0=y0%windowHeight;
  if(y0<-1000)y0=y0%windowHeight+windowHeight;

  // Use fill() to change the value or color of the text
  fill(205);
  text("Score: ", 8, 25);text(score, 110, 25);
  m = millis();
  fill(224);
  // 3 min limited
  if(m<1000*60*2){
    text("Time Left:            min", 8, 60);text(3-(m/60000), 110, 60);
  }else if(m<1000*60*3){
    text("Time Left:            sec", 8, 60);
    fill(233,68,65);text(3*60-(int)(m/1000), 110, 60);
  }//else exit();
}

void buttonRandL()
{
    if(myPort.available()>0){
     if(myPort.readBytesUntil(10,inBuffer)>0){//Read to determine whether the wrap 10BYTE
      String inputString = new String(inBuffer);
      String inputStringArr[] = split(inputString,',');//Data ',' Split
      Rw[0] = int(inputStringArr[0]);//Read the X value
      Rw[1] = int(inputStringArr[1]);//Read the y value
    }
  }
   if ((direction == 1) & (Rw[0]==0))
   {
     x0 += 2 * r * cos(theta);
     y0 += 2 * r * sin(theta);
     theta -= PI;
     direction *= -1;
   }
   if ((direction == -1) & (Rw[1]==0))
   {
     x0 += 2 * r * cos(theta);
     y0 += 2 * r * sin(theta);
     theta += PI;
     direction *= -1;
   }
}

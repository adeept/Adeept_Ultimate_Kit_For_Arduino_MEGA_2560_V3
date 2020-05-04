/******************************************************************************
File name:   Processing_PS2Joystick_Button.pde
Description: Arduino and processing interactive
             Button and Joystick control Star Wars game
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19 
********************************************************************************/ 
import processing.serial.*; //Transferred to the serial library
import processing.sound.*; 


SoundFile file;//Create SoundFile objects file 
FFT fft;       //Create FFT objects fft 
Serial myPort; //Create Serial objects myPort 
PImage img;    

int Rw[] = new int[3];
byte inBuffer[] = new byte[100];
int fire[]=new int[1];

Sky stars = new Sky();
Rect rect1;
Box[] boxes;
Time timer;
Drop[] drop;
PImage head;
int totaldrop=0;
int totalboxes=0;
void setup(){
  file = new SoundFile(this,"Linked Horizon.mp3");
  file.play(); 
  size(560,600);
  // Open the serial port and set the baud rate to 9600
  // This experiment arduino board is connected to COM26, here please
  // 
  myPort = new Serial(this,"COM26",9600);
  img = loadImage("LOGO11.png");
  fire[0] = 0;
  smooth();
  rect1=new Rect(); //The initial 'game over' range
  stars.setup(); 
  head = loadImage("airplane.png");//Load fighter picture
  timer=new Time(300);
  drop=new Drop[1000];//Initialization bullet
  boxes=new Box[100];//Initial enemy warplanes
  timer.start();
}
void draw(){
  background(0);  //Set on a black background
  readSensors();  //Detection Arduino information
  rect1.setlocation(-Rw[1]/2+275,-Rw[0]/2+550); 
  rect1.display();
  stars.move(); //Display the stars
  stars.display(); 
  imageMode(CENTER);
  image(head,-Rw[1]/2+275,-Rw[0]/2+550);//Display the fighter
  if(timer.isFinished()){
    drop[totaldrop]=new Drop();
    boxes[totalboxes]=new Box();
    totaldrop++;
    totalboxes++;
    if(totaldrop>=drop.length){
      totaldrop=0;
    }
    if(totalboxes>=boxes.length){
      totalboxes=0;
    }
    timer.start();
  }
  if(fire[0]==1){
    for(int i=0;i<totaldrop;i++){ 
      drop[i].move();     
      drop[i].display();
    }
  }
  for(int j=0;j<totalboxes;j++){
    boxes[j].move();
    boxes[j].display();
    for(int i=0;i<totaldrop;i++){
      if(drop[i].intersect(boxes[j])){
        boxes[j].caught();
        drop[i].caught1();
      }
      if(rect1.inter(boxes[j])){
        gameover();
       // boxes[j].stop1();
        //drop[i].stop2();
      }
    }
  }
  image(img,520,550);
}
void gameover() { //Display 'game over' information
  fill (240, 40, 40); 
  textSize (86); 
  textAlign(CENTER); 
  text ("Game Over", width/2, height/2);
} 
class Time{//Run time
  int savedtime;
  int totaltime;
  Time(int temptotaltime){
    totaltime=temptotaltime;
  }
  void start(){
    savedtime=millis();
  }
  boolean isFinished(){
    int passedtime=millis()-savedtime;
    if(passedtime>totaltime){
      return true;
    }else{
      return false;
    }
  }
}
class Drop{//Display bullets position
  float x,y;
  float r;
  float speed;
  color c;
  Drop(){
    if(Rw[2]==0){
    r=3;
    y=-Rw[0]/2+550;
    x=-Rw[1]/2+275;
    speed=30;//random(6,9);
    c=color(255,0,0);
    fire[0]=1;
    }
  }
  void move(){
    y=y-speed;
  }
  void display(){
    noStroke();
    fill(c);
    for(int i=9;i>r;i--){
      ellipse(x,y-i*6,i*2,i*2);
    }
  }
  boolean intersect(Box b){
    float distance=dist(x,y,b.x,b.y);
    if(distance<r+55){
      return true;
    }else{
      return false;
    }
  }
  void caught1(){
    speed=0;
    y=-1000;
  }
  void stop2(){
    speed=0;
  }
}
class Box{//Display enemy warplanes location
  float x = random(width); 
  float y = random(1); 
  int life; 
  int speed;
  Box(){
    life = 3; 
    speed =1; 
  }
  void display(){
    ellipseMode (CENTER); 
    rectMode (CENTER); 
    stroke (255); 
    strokeWeight (1); 
    fill (45, 37, 100); 
    rect (x, y-15, 65, 6); 
    rect (x, y-15, 85, 5); 
    arc (x, y-8, 16, 35, PI, PI*2); 
    ellipse (x, y-10, 35, 16); 
    fill (0, 80, 192); 
    ellipse (x-26, y-15, 13, 13); 
    ellipse (x+26, y-15, 13, 13); 
    fill (99, 173, 242); 
    ellipse (x+26, y-15, 5, 5); 
    ellipse (x-26, y-15, 5, 5); 
  }
  void move(){
    y=y+speed;
  }
  void caught(){
    speed=0;
    y=-1000;
  }
  void stop1(){
    speed=0;
  }
}
class Sky { 
  int n = 60; 
  float speed = 1; 
  float[] x = new float [n]; 
  float[] y = new float [n]; 
  float[] d = new float [n]; 

Sky () { 
} 

void setup() { 
  for (int i=0; i<n; i++) { 
  if (i%5 == 0) 
  d[i] = random (0, 2); 
  else 
  d[i] = 3; 
  x[i] = random (0, width); 
  y[i] = random (-height, height*2); 
} 
} 
void move() { 
  for (int i=0; i<n; i++) { 
  y[i] += d[i]*speed; 
  if (y[i]>height*2) 
  y[i] = random (-height-100, -height+100); 
} 
} 
void display() { 
  fill (255); 
  noStroke(); 
  for (int i=0; i<n; i++) { 
    ellipse (x[i], y[i], d[i], d[i]); 
  } 
} 
}
class Rect{
  float x;
  float y;
  float w;
  float h;
  Rect(){
    x=0;
    y=0;
    w=85;
    h=60;
  }
  void setlocation(float tempx,float tempy){
    x=tempx;
    y=tempy;
  }
  void display(){
    noStroke();
    fill(0);
    rectMode(CENTER);
    rect(x,y,w,h);
  }
  boolean inter(Box b1){
    float distance1=dist(x+40,y+30,b1.x+40,b1.y+6);
    if(distance1<70){
      return true;
    }else{
      return false;
    }
  }
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
      if(Rw[0]<0){
      Rw[0]=0;
      }
      Rw[1] = Rw[1] - 515;//Converted to negative (rocker line out)
    }
  }
}

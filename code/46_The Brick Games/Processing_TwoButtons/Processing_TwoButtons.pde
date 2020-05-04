/***********************************************************
File name:   Processing_TwoButtons.pde
Description: Arduino and processing interactive
             Two buttons control the Brick Game
Website: www.adeept.com
E-mail: support@adeept.com
Exchange learning community: https://www.adeept.com/forum/
Author: Tom
Date: 2019/02/19
***********************************************************/
import ddf.minim.*;         //Load the minim library
import processing.serial.*; //Load the serial library


Serial myPort;//Create Serial objects myPort 
PFont font;//Create font Variables
int Rw[] = new int[3];
byte inBuffer[] = new byte[100];

Minim minim; 
AudioPlayer song;
//Define the timer
int jsq=0;
int yxcs=2;
import processing.video.*;  //Load the video library
//Define the display text
PFont f;
//Define the opening button
boolean button0=true;
boolean button1=false;
//Define the main menu button
boolean buttoncd1=false;
boolean buttoncd2=false;
boolean buttoncd3=false;
boolean buttoncd4=false;
//Define the selection of level button
boolean buttongk1=false;
boolean buttongk2=false;
boolean buttongk3=false;
boolean buttongkfh=false;
//Define the custom help button
boolean buttonbzfh=false;
//Define the first back button
boolean buttonfh1=false;
boolean buttonfh2=false;
boolean buttonfh3=false;
//Initialize the button value
int maxImages = 7;   // The total number of the background pictures
int imageIndex = 1;  // The original picture is displayed first
int maxImages1 = 30; //The total of button pictures 
int maxImages2 = 4;  //Choose the total of level button pictures
//Apply a background image array.
PImage[] images = new PImage[maxImages];
//Apply a button image array.
PImage[] images1 = new PImage[maxImages1];
//Apply and select the level of button image array.
PImage[] images2 = new PImage[maxImages2];

float ball_x;
float ball_y;
float ball_dir = 1;   //Speed of the ball
float ball_size = 10; //Radius of the ball
float dx = 0;         //Direction
int cs=5;
int csl=10;
int zkzs=cs*csl;
int zksl=6;
PImage[] zky=new PImage[zksl];
PImage[] zkxs=new PImage[zkzs];
int[] xsbz=new int[zkzs];
int zkwidth=40;
int zkheight=17;
boolean flg=false;

float imgx,imgy,con;
float movx,movy,pmovx;
int index=0;
boolean videoflg=false;	 
//The size of each grid
int videoScale =1;
//The number of rows and columns in our system
int cols, rows;
//Capture Object
//GSCapture video;
Capture video;
PImage img;

int paddle_width = 60;
int paddle_height = 5;
int dist_wall = 120;
     
void setup(){
    size(400,520);
  // Open the serial port and set the baud rate to 9600
  // This experiment arduino board is connected to COM26, here please
  // adjust according to actual situation.
  myPort = new Serial(this,"COM26",9600);
    colorMode(RGB,255,255,255);
    f = createFont("KaiTi_GB2312-48", 12, true); 
////    rectMode(CENTER_RADIUS);
////    ellipseMode(CENTER_RADIUS);
    rectMode(CENTER);
    ellipseMode(CENTER);
    rectMode(RADIUS);
    ellipseMode(RADIUS);
    noStroke();
    smooth();
    ball_x = width/2;
    ball_y = cs*zkheight+ball_size+1; 
    tupian();
    csh();
    sxtcsh();
    loadPixels();
    minim = new Minim(this); 
    song = minim.loadFile("Yiruma - Kiss The Rain.mp3"); 
    song.play(); 
}
void draw(){
   background(0);
   readSensors();
   
   //Opening
   if (button0){
      kc();
   }
   //Click the button icon to enter the main menu
   if(button1){
     zcd();
     button0=false;
   }
   //Click the button icon to enter the game (default first No.1)
   if(buttoncd1){
     if(jsq< yxcs){
         dzk();
         button0=false;
         button1=false;
         buttoncd2=false;
         buttoncd3=false;
     }
     else
     {
       buttoncd1=false;
       button1=true;
       jsq=0;
       csh();
      }
      if(buttonfh1){   
        buttoncd1=false; 
        button1=true;     
      }  
    }
    //Click the button icon to enter the level select
    if(buttoncd2){   
      gk();
    }
    if(buttongkfh){ 
         buttoncd2=false;
         button1=true;
     }       
    //Click the button icon to access the help
    if(buttoncd3){ 
         bz();  
        if(buttonbzfh){
           buttoncd3=false;
         }   
     } 
    //Click the button icon to quit the game
    if(buttoncd4){ 
//   video.stop();
//   video.dispose();
     exit();
    }  
}
void kc(){
  //Background display
  image(images[1],0,0,400,520);
  //Build button icon
  image(images1[0],133,175,132,166);
  //image(images1[0],200,300,20,20);
}
void zcd(){
    //Display the main of menu background
    image(images[2],0,0,400,540);
    //Build button icon
    image(images1[1],160,90,70,30);
    image(images1[2],160,135,70,30);
    image(images1[3],160,180,70,30);
    image(images1[4],160,220,70,30);
}

void dzk(){
    //Build button icon
    image(images1[5],180,490,50,30);
     pzjc();//Detect collision 
     movxy();//Baffle movenent 
     playzk();//Display bricks
     
     ball_y += ball_dir * 1.0;
     ball_x += dx;
     if(ball_y > (height-100)+ball_size) 
     {
        ball_y = cs*zkheight+ball_size+1;
        ball_x = random(0, width);
        dx = 0;
        jsq ++;
        println(jsq);
      }  
   readSensors();
  // Constrain paddle to screen
  float paddle_x = constrain(movx, paddle_width, width-paddle_width);
  float px = height-dist_wall-paddle_height-ball_size;
  if(ball_y == px 
     && ball_x > paddle_x - paddle_width - ball_size 
     && ball_x < paddle_x + paddle_width + ball_size) {
     ball_dir *= -1;
     if(movx != pmovx) {
      dx = (movx-pmovx)/2.0;
      if(dx >  5) { dx =  5; }
      if(dx < -5) { dx = -5; }
    }
  }   
    readSensors();
  // If ball hits paddle or back wall, reverse direction
  if(ball_y < ball_size && ball_dir == -1) {
    ball_dir *= -1;
      }  
  // If the ball is touching top or bottom edge, reverse direction
  if(ball_x > width-ball_size) {
    dx = dx * -1;
  }
  if(ball_x < ball_size) {
    dx = dx * -1;
  }
  // Draw ball
  fill(255,0,0);
  ellipse(ball_x, ball_y, ball_size, ball_size);  
  // Draw the paddle
  fill(255,255,0);
  rect(paddle_x, height-dist_wall, paddle_width, paddle_height);  

}

void gk(){
   image(images[4],0,0,400,540);
   image(images2[1],160,80,60,30);
   image(images2[2],100,180,60,30);
   image(images2[3],220,180,60,30);
   image(images1[5],160,280,60,30);
}

void bz(){
          image(images1[6],0,0,400,540);
          image(images1[5],300,350,50,30);
          String message = "When the players enter the game, the players need to use the Arduino\n keyboard to control the game.Damper control direction and speed of\n the ball";
          fill(0);
          textFont(f);
          text(message,10,150);
}
void mousePressed(){
    //Define the scope of the button icon
     if (button0){
          if(mouseX>133&&mouseX<265&&mouseY>165&&mouseY<327){          
          button1=true;
          button0=false;
         }
     }else{
      if(mouseX>160&&mouseX<230&&mouseY>90&&mouseY<120){
        buttoncd1=true;
        button0=false;
        button1=false;
        paddle_width = 60;
        paddle_height = 5;
        dist_wall = 120;
       }
      else if(mouseX>160&&mouseX<230&&mouseY>135&&mouseY<165){
        buttoncd2=true;
        buttoncd3=false;
        buttoncd1=false;
       }
      if(mouseX>160&&mouseX<230&&mouseY>180&&mouseY<210){
       buttoncd3=true;
       buttoncd1=false;
       buttoncd2=false;
      }
      else if(mouseX>160&&mouseX<230&&mouseY>220&&mouseY<250){
       buttoncd4=true;
      }
      //Define the scope of 'level' button icon
       if(mouseX>160&&mouseX<220&&mouseY>80&&mouseY<110){
       paddle_width = 60;
       paddle_height = 5;
       dist_wall = 120;
       buttoncd2=false;
       buttoncd1=true;
        ball_x = width/2;
        ball_y = cs*zkheight+ball_size+1;
         jsq=0;
         csh();  
       }
       else if(mouseX>100&&mouseX<160&&mouseY>180&&mouseY<210){
        paddle_width = 40;
        paddle_height = 5;
        dist_wall = 150;
        buttoncd2=false;
        buttoncd1=true;
         ball_x = width/2;
         ball_y = cs*zkheight+ball_size+1;
         jsq=0;
         csh();
       }
        if(mouseX>220&&mouseX<280&&mouseY>180&&mouseY<210){
        paddle_width = 20;
        paddle_height = 5;
        dist_wall = 180;
        buttoncd2=false;
        buttoncd1=true;
         ball_x = width/2;
         ball_y = cs*zkheight+ball_size+1;
         jsq=0;
         csh();
       }
       if(mouseX>160&&mouseX<220&&mouseY>280&&mouseY<310){
         buttongkfh=true;
         buttoncd1=false;
         buttoncd2=false;
         buttoncd3=false;
         buttongkfh=false;
      }
      // Define the scope of 'help' button icon
       if(mouseX>300&&mouseX<350&&mouseY>350&&mouseY<380){
       buttonbzfh=true;
       buttoncd3=false;
       buttonbzfh=false;
     }
     //Define the scope of 'back' button icon
      if(mouseX>180&&mouseX<230&&mouseY>490&&mouseY<520){
        buttoncd1=false;
        buttoncd2=true;
        button1=true;
     }
   }
}
 
void stop() //Control music player
	{ 
	  song.close(); 
	  minim.stop(); 
	  super.stop();
}
void tupian(){
  //Loading pictures in the array
  for (int i = 1; i < images.length; i ++ ) {
    images[i] = loadImage( "Bj" + i + ".jpg" );
  }
  for (int i = 1; i < images2.length; i ++ ) {
    images2[i] = loadImage( "g"  + i +".jpg" );
  }
  String []filenames = {"go.jpg","jr.jpg","xz.jpg","bz.jpg" , "tc.jpg", "fh.jpg", "bzbj.jpg"};
   for (int i = 0; i <filenames.length; i++)  {    
    images1[i] = loadImage(filenames[i]);  
   }
}
void csh()
{
  for (int i=1;i<=6;i++)
  {
    zky[i-1]=loadImage("zk"+i+".jpg");
  }
  for (int i=0;i<zkzs;i++)
  {
    xsbz[i]=1;
  }
  for (int i=0;i<zkzs;i++)
  {
    int j=int(random(zksl));
    zkxs[i]=zky[j];
  }
}
void playzk()
{
  int i,j;
  for ( i=0;i<cs;i++)
  
    for ( j=0;j<csl;j++){
   
      if (xsbz[j+i*csl]>0)
      {
       //image(zkxs[j+i*csl],j*zkwidth,i*zkheight);
       image(zkxs[j+i*csl],j*zkwidth,i*zkheight);
       }   
    }   
}
void pzjc()
{
  int j=int( ball_x/zkwidth);
   int i=int((ball_y-ball_size)/zkheight);
   if (i<cs)
   {
     if (xsbz[j+i*csl]==1){
     ball_dir *= -1;
     xsbz[j+i*csl]=0;
     }
   }
}

void sxtcsh()
{
  movx=0;
  movy=0;
  
  video = new Capture(this,640,480,155);
  cols = 640/videoScale;
  rows = 480/videoScale;
  img = createImage(640,480,RGB);
  img.loadPixels();
}
void movxy()
{  
   image(img,0,0);
   readSensors();
   pmovx=movx;
   movx=2*Rw[2];//int(imgx/con);
   movy=int(imgy/con);
   println("x="+int(movx));
   println("y="+int(movy)); 

}
void  readSensors(){
  if(myPort.available()>0){
     if(myPort.readBytesUntil(10,inBuffer)>0){//Read to determine whether the wrap 10BYTE
      String inputString = new String(inBuffer);
      String inputStringArr[] = split(inputString,',');//Data ',' Split
      Rw[0] = int(inputStringArr[0]);//Read the right value
      Rw[1] = int(inputStringArr[1]);//Read the left value
     }
   }
      if(Rw[0]==0&Rw[1]==1)
      {
        if(Rw[2]>=0)
        {
          Rw[2]--;
        }else{
          Rw[2]=0;
        }
      }
      if(Rw[0]==1&Rw[1]==0)
      {
        if(Rw[2]<=200)
        {
          Rw[2]++;
        }else{
          Rw[2]=200;
        }
      }
   pmovx=movx;
   movx=2*Rw[2];//int(imgx/con);
   movy=int(imgy/con);
   // println("Rw[0]="+Rw[0]);
}

#include <AFMotor.h>  
//^^ ladyada's great moto shield library


AF_Stepper motor(48, 1); //sets up motor1 (x axis)
AF_Stepper motor2(48, 2); //set up motor2 (y axis)

int stepsize=50;  //this will change depending on our gearing
int delays=1000; //this will change depending on the time needed to burn 

int ledPin=14; //debug, will not be used in final

//all analogue pins (can be used as digital) and ditial pins are available for the laser



void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("BUILDS Drawbot");


  motor.setSpeed(200);  // fastest is 255, we have to adjust these to get good performance and time 


  motor2.setSpeed(200);  // same as above ^^
  
  
  delay(delays); 
  
  pinMode(ledPin, OUTPUT);  //wont be used in final, just for debugging

}


char getsize() {  //pixelsize.pl sends the size over serial, don't worry about it drawbot.sh handles that
  while(Serial.available()==0) {
  } // wait till next char is available
  char sz=Serial.read();

  return sz;
}

int intcreator(char gsize){  //some magic turning the size to an integer
  char *zs = &gsize;
  int sizes=int(atoi(zs));
//  Serial.print(sizes);
  return sizes;
}
  
char nextchar() {   // take a peek at the next value over serial, we get this from bitstream.pl
  while(Serial.available()==0) {
  } // wait till next char is available
  char ch=Serial.read();
  //Serial.print(ch,DEC);
  Serial.print(ch);
  return ch;
}

void lightup(int location) {  //will eventually be replaced with burnation for laser
  if (location==1){
    digitalWrite(ledPin,HIGH);
    delay(delays);
    digitalWrite(ledPin,LOW);
  }
  else if (location==0){
    delay(delays);}
  else{
    delay(delays);}
}



void loop() {  // main program
Serial.println("Jeff Crowell; Samir Ahmed - 2011"); // 1sted
int pixels; 
char pixchar=int(getsize()); //get the size of the pixels

int numpix=intcreator(pixchar); // wow what am I doing

Serial.print(int(numpix));
pixels=int(numpix); //magic, its the pixels!
pixels=pixels-1; //fixes a counting error, we had 1 too many steps per row and 1 too many columns due to this
//Serial.print(pixels); 

  // ----------- STROKE MODE --------------------
  
  /*Moving foward on
         x----pixels->     // Will move forward (pixels) steps
                       y   
                       |   // Will move downwards 1 step
                       v
         <----pixels--x    // Will move backwards 1 step
        y
        |
        v
         x----pixels->        
  */
  
  for (int county=0;county<pixels+1;county++)
  {
    if ((county%2)==0) //we should go l-r
    {
      for (int countx=0;countx<pixels;countx++)
      {
        
        char location=nextchar();
        char *loca = &location;
        int bits=int(atoi(loca));
        lightup(bits);
        motor.step(stepsize,FORWARD,INTERLEAVE);
        Serial.println("moved right");

        delay(delays);
      }
    }
    else //we should go r-l
    {
      for(int countx=0;countx<pixels;countx++)
      {
        char location=nextchar();
        char *loca = &location;
        int bits=int(atoi(loca));
        lightup(bits);
        motor.step(stepsize,BACKWARD,SINGLE);
        Serial.println("moved left");

        delay(delays);
      }
    }
    motor2.step(stepsize,BACKWARD,SINGLE);    // Note there will be an extra drop down to account for
    Serial.println("moved down");
    delay(delays);
    }
    
    // ------------------ RETURN TO CENTER --------------------
    // Overshoot the start point so we can move back into position without backlash
    
    Serial.println("RETURNING TO INITIAL POSITION");
    // Ideally step size is one and pixels is the step to return home
    motor2.step((pixels*stepsize+6),FORWARD,SINGLE);          // Overshoot by 5 places (1 from extra and 5 overshoots)
    motor2.step(5,BACKWARD,SINGLE);                           // Move back 5
   
    if ((pixels%2)==0)
    {
      motor.step(5,FORWARD,SINGLE);                           // Moves Forwards 5 MAKE FUCNTION CALLED BACKLASH
      motor.step((pixels*stepsize+10),BACKWARD,SINGLE);       // Overshoot by 5
      motor.step(5,FORWARD,SINGLE);                           // Move Back 5
    }
    
    // -------------------- RELEASE STEPPER --------------------
    motor.release();
    motor2.release();
    exit(0);
}

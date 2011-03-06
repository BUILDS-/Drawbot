#include <AFMotor.h>


AF_Stepper motor(48, 1); //sets up motor1
AF_Stepper motor2(48, 2); //set up motor2

int stepsize=5;
int delays=1;
int burndelay=5;

int ledPin=14;



void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("I'm-a Chargin' mah laser!");
  motor.setSpeed(200);  
  motor2.setSpeed(200);    
  pinMode(ledPin, OUTPUT);
}




int getsize() {    //pixelsize.pl sends the size over serial, don't worry about it drawbot.sh handles that

  // Current support is for ONLY THREE DIGIT NUMBERS

  while(Serial.available()==0) {}
  int sz100=int(Serial.read()) - 48; // Converts to a decimal digit for the hundreds place
  
  while(Serial.available()==0) {}
  int sz10=int(Serial.read()) - 48;   // Converts to a decimal digit for the tens place

  while(Serial.available()==0) {}
  int sz1=int(Serial.read()) - 48;    // Converts to a decimal digit for the units place
  
  int gsize=sz100*100+sz10*10+sz1;    // MULTIPLYING by orders of 10 to assign relative magnitudes

  Serial.print("the size of this file is ");
  
  
  
  return gsize;
  
}
  
char nextchar() {   // take a peek at the next value over serial
  while(Serial.available()==0) {
  } // wait till next char is available
  char ch=Serial.read();
  Serial.print("the next char is ");
  Serial.println(ch);
  
  return ch;
}


void lightup() {  //will eventually be replaced with burnation for laser

  digitalWrite(ledPin,HIGH);
  delay(delays);
  digitalWrite(ledPin,LOW);
}



void loop() {  // main program
Serial.println("BUILDS Drawbot - Jeff Crowell; Samir Ahmed"); // 1sted
int pixels=getsize(); 


Serial.println(pixels); 

  // ----------- STROKE MODE --------------------
  
  /*Moving foward on
         x----pixels->     // Will move forward (pixels) steps
         
                       y   
                       |   // Will move do
                       wnwards 1 step
                      v
         <----pixels--x    // Will move backwards 1 step
        y
        |
        v
         x----pixels->        
  */
  
  for (int county=0;county<pixels;county++)
  {
    
    if ((county%2)==0) //we should go l-r
    {
      for (int countx=0;countx<pixels-1;countx++)
      {
        if (countx==0){       
        char location=nextchar();
        if (location=='1')
        {
          lightup();
        }
        }
    
        motor.step(stepsize,FORWARD,INTERLEAVE);
        Serial.println("moved x >");
        char 
        
        location=nextchar();
        
        
        if (location=='1')
        {
          lightup();
        }

        delay(delays);
      }
    }
    else //we should go r-l
    {
      for(int countx=0;countx<pixels-1;countx++)
      {
        if (countx==0){          
          char location=nextchar();
          if (location=='1')
          {
            lightup();

          }                      
        }    
        motor.step(stepsize,BACKWARD,INTERLEAVE);
        Serial.println("moved x <");
        
        char location=nextchar();
        if (location=='1')
        {
          lightup();
        }

        delay(delays);
      }
    }
    motor2.step(stepsize,BACKWARD,SINGLE);    // Note there will be an extra drop down to account for
    Serial.println("moved y v");
    delay(delays);
    }
    
    // ------------------ RETURN TO CENTER --------------------
    // Overshoot the start point so we can move back into position without backlash
    
    
    // Ideally step size is one and pixels is the step to return home
    Serial.println("returning to home");
    motor2.step((pixels*stepsize+6),FORWARD,SINGLE);          // Overshoot by 5 places (1 from extra and 5 overshoots)
    motor2.step(5,BACKWARD,SINGLE);                           // Move back 5
   
    if ((pixels%2)==1)
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



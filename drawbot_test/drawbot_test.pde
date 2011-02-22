// BUILDS Drawbot using Adafruit Motor shield library
// Jeff Crowell/BUILDS 2011
//because lasers can be dangerous similar warnings should apply to all things this
//THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//IN NO EVENT SHALL JEFFREY CROWELL OR ANY OTHER CONTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#include <AFMotor.h>

//Set up motors
AF_Stepper motorx(48, 1);  //motor1 (48steps per revolution [7.5 degree] (port1)(controlling x axis)
AF_Stepper motory(48,2);  // motor 2 same as above port 2, control y axis
// still need laser control, I can add that later when we get all parts, probably just with digitalWrite easy. 
char image[]="0010001100101101000110101" //will convert image to a string in matlab, script for that mostly done
//this image stuff is probably better off loaded from an SD card or something so that arduino doesnt need reprogramming every time we make a new picture
//there are sd card breakout stuff, like $10, so should be easily doable
int killSwitch 3;  //flip to start/stop
int countx=0; //set up our counters
int county=0;
int currentPixel=0;
int imageSize=5;   //here we assume a 5x5 pixel "image" which is terribly stupid, but I have no idea how we will need to gear the etch-a-sketch for good resolution, so bear with it

void setup() {
  Serial.begin(9600); // set up Serial library at 9600 bps
  Serial.println("BUILDS cnc laser drawbot");
  motor.setSpeed(10); // 10 rpm
}

void loop() {
  while (digitalRead(killSwitch) == HIGH) {  //only go if a killswitch is switched on

  for (county=0;county<imageSize;county++){  //y direction counter/moving
    if (county%2==0) { // should we go left or right?
      for (countx=0;countx<imageSize;countx++)
      {
        if (image[currentPixel]=="1"){
          //fire laser
        }
        motorx.step(100,FORWARD,SINGLE);
        currentPixel++;
      }
    }
    else if (county%2==1) {
      for (countx=imageSize;countx>0;countx--)
      {
        if (image[currentPixel]=="1"){
          //fire laser
        }
        motorx.step(100,BACKWARD,SINGLE);
        currentPixel++;
      }
    }
    else 
    {
     Serial.println("Jeff has buggy code, sorry the target for engraving is already destroyed");
     break;
    }
    motory.step(100,FORWARD,SINGLE);
    currentpixel++;
  }
  Serial.println("FINISHED, WILL NOW BREAK LOOP AND STOP LASER");
  //turn off laser
  //return steppers to starting position
  for (int ii=0;ii<imageSize;ii++)
  {
    motory.step(100,BACKWARD,SINGLE);
  }
  for (int ii=0;ii<imageSize;ii++)
  {
    motorx.step(100,BACKWARD,SINGLE);
  }
  break;
  }
   else { // if the switch is switched, do this stuff.
     Serial.println("I'm charging my laser");
     Serial.println("flip the switch to start");
     Serial.println("but make sure you have the right image loaded");
     Serial.println("and that the surface is underneath the drawbot");
     delay(10000);
   }
}

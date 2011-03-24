#! /usr/bin/env python

import serial
ser = serial.Serial(port='/dev/ttyACM0', baudrate=9600, bytesize=8, parity='N', stopbits=1) #sets arduino as serial device to receive the bits

ser.open()
bitstreamId = open('drawbot1.txt', 'r') #loads bitstream as readable file
bitstream=bitstreamId.read()
count=0
for chars in bitstream:
  while(ser.inWaiting() != 0 ): #wait around for buffer to be emptied by arduino
    print ""
  ser.write(chars) #send next bit over to arduino as a character

bitstreamId.close()
print "Your object is now destroyed..."
print "I mean beautifully etched"
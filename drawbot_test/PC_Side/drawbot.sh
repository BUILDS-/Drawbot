#! /bin/bash
# Jeff Crowell/Samir Ahmed/BUILDS
# CNC Drawbot

#send over the size of the image
perl pixelsize.pl
sleep 1

#send over each bit of the bitstream
perl bitstream.pl
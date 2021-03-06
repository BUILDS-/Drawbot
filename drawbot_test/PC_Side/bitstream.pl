use Device::SerialPort;
use Time::HiRes "usleep";
#microsleeping
# Set up the serial port /dev/ttyACM0 is it on my uno, may be different for you.

my $port = Device::SerialPort->new("/dev/ttyACM0");
#sending a char(mander) hence the 8 bits
$port->databits(8);
#arduino listens at 9600 baud
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);
# open the file
open(FILE, 'drawbot1.txt') or die "HALP, I'M DYING 'filename' [$!]\n"; 
$bitstream = <FILE>;  
close (FILE);  
sleep undef,undef,undef,0.1;
#keep a counter of which bits we have sent
my $count = 1;

#loop through the file, send one char at a time
while (count < (length $bitstream))
{
#give the arduino a chance to catch up
usleep 10000;
#grab the next char
$current=substr $bitstream,$count,1;
#send it over to arduino
$port->write($current);
$count++;
}   

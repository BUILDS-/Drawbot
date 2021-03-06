use Device::SerialPort;

#this is the serial port of my arduino uno, modify this to be the port of your arduino
my $port = Device::SerialPort->new("/dev/ttyACM0"); 
#we send over an "integer", thus must be 32 bits
$port->databits(8);
#arduino listens at 9600 baud
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);
#load the file
open(FILE, 'drawbot1.txt') or die "HALP, I'M DYING 'filename' [$!]\n"; 
$bitstream = <FILE>;  
close (FILE);  
#find the dimensions of it
$pixels =sqrt(length $bitstream);
print int($pixels);
#shoot the dimensions over to arduino
$port->write($pixels);
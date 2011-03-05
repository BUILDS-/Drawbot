# Sample Perl script to transmit bitstream
# to Arduino then listen for the Arduino
# to echo it back 

use Device::SerialPort;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyACM0");
$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);
open(FILE, 'drawbot1.txt') or die "HALP, I'M DYING 'filename' [$!]\n"; 
$bitstream = <FILE>;  
close (FILE);  
$pixels =sqrt( length $bitstream);
print $pixels;
#$port->write($pixels);
sleep 1;
#  while (count < length $bitstream) {
#     # Poll to see if any data is coming in
#     my $char = $port->lookfor();
#     # If we get data, then print it
#     # Send a number to the arduino
#         sleep(1);
#         $count++;
# 	$current=substr $bitstream,$count,1;
#         my $count_out = $port->write("$current\n");
#         print "Sent     character: $current \n";

my $count = 0;
#$port->databits(8);
while (count < (length $bitstream))
{
sleep 1;
$current=substr $bitstream,$count,1;
# my $char = $port ->lookfor();
 $port->write($current);
$count++;
}   

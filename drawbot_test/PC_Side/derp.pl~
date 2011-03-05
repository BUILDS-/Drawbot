use Device::SerialPort;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyACM0");
$port->databits(32);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);
open(FILE, 'drawbot1.txt') or die "HALP, I'M DYING 'filename' [$!]\n"; 
$bitstream = <FILE>;  
close (FILE);  
$pixels =sqrt( length $bitstream);
print $pixels;
$port->write($pixels);
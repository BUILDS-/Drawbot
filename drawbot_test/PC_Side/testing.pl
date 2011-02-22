# Sample Perl script to transmit bitstream
# to Arduino then listen for the Arduino
# to echo it back 

use Device::SerialPort;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyUSB0");
$port->databits(8);
$port->baudrate(19200);
$port->parity("none");
$port->stopbits(1);
open(FILE, 'drawbot1.txt') or die "HALP, I'M DYING 'filename' [$!]\n"; 
$bitstream = <FILE>;  
close (FILE);  
#print $bitstream;
$pixels =sqrt( length $bitstream);
$port->write($pixels);
my $count = 0;
my $count2 = 0;
while (count2=0){
  sleep(1);
  $current=$pixels;
  my $count_out = $port->write($current);
  $count2++;
}
 while (1) {
    # Poll to see if any data is coming in
    my $char = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($char) {
        print "Recieved character: " . $char . " \n";
    } else {
        sleep(1);
        $count++;
	$current=substr $bitstream,$count,1;
        my $count_out = $port->write("$current\n");
        print "Sent     character: $current \n";
    }
}

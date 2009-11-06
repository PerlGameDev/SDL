
my @files = qw/
ActiveEvent  	
KeyboardEvent  	
TextInputEvent  	
MouseMotionEvent  	
MouseButtonEvent  	
JoyAxisEvent  	
JoyHatEvent  	
JoyButtonEvent 	
JoyBallEvent  	
ResizeEvent  	
ExposeEvent  	
SysWMEvent  	
UserEvent  	
QuitEvent  	
keysym 		
/;

foreach (@files)
{
   my $file = $_;
   my $fn = $file.'.pm';
   open FH, ">$fn";
   print FH 
"package SDL::$file;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our \@ISA = qw(Exporter DynaLoader);
bootstrap SDL::$file;
1;";
   close FH;
}



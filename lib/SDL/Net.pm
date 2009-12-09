package SDL::Net;
use strict;
use warnings;
require Exporter;
require DynaLoader;
use vars qw(@ISA @EXPORT);

BEGIN {
	@ISA = qw(Exporter DynaLoader);
	@EXPORT = qw(
       		INADDR_BROADCAST
        	SDLNET_MAX_UDPCHANNELS
        	SDLNET_MAX_UDPADDRESSES );      
}


bootstrap SDL::Net;

#use constant
#{
#	INADDR_ANY =>              0x00000000,
#	INADDR_NONE =>             0xFFFFFFFF,
#};
use constant
{
	INADDR_BROADCAST =>        0xFFFFFFFF,
	SDLNET_MAX_UDPCHANNELS =>  32,
	SDLNET_MAX_UDPADDRESSES => 4
};


1;

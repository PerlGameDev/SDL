package inc::Utility;
use strict;
use warnings;
use Carp;

BEGIN{
	require Exporter;
	our @ISA = qw(Exporter);
	our @EXPORT_OK = qw(sdl_con_found sdl_libs sdl_c_flags); 
}

#checks to see if sdl-config is availabe
#
sub sdl_con_found
{
	`sdl-config --libs`;
	return 0 if ($? >> 8);
	return 1;
}

sub sdl_libs
{
	if(sdl_con_found)
	{
		local $_ = `sdl-config --libs`;
		return chomp($_);
	}
	else
	{
		return undef;
	}
}

sub sdl_c_flags
{
        if(sdl_con_found)
        {
               	local $_  = `sdl-config --cflags`;
		return chomp($_);
        }
	else
	{
		return undef;
	}
}

1;

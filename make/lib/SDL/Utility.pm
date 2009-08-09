package SDL::Utility;
use strict;
use warnings;
use Carp;


BEGIN{
	require Exporter;
	our @ISA = qw(Exporter);
	our @EXPORT_OK = qw(sdl_con_found sdl_libs sdl_c_flags); 
}
	my $arch =  SDL::Build->get_arch( $^O );

use lib '../';
use SDL::Build;

#checks to see if sdl-config is availabe
#
sub sdl_con_found
{
	`sdl-config --libs`;
	return 0 if ($? >> 8);
	return 1;
}

#This should check if the folder actually has the SDL files
sub check_sdl_dir
{
	return 0 unless $ENV{SDL_INST_DIR} and return $ENV{SDL_INST_DIR};
}

sub sdl_libs
{
	if(sdl_con_found)
	{
		local $_ = `sdl-config --libs`;
		return chomp($_);
	}	
	elsif( check_sdl_dir() )
	{
		return $arch->alt_link_flags( check_sdl_dir() ) ;
	}
	else
	{
		#ask to download
		croak 'SDL not installed';
		return 0;
	}
}

sub sdl_c_flags
{
        if(sdl_con_found)
        {
               	local $_  = `sdl-config --cflags`;
		return chomp($_);
        }
	elsif ( check_sdl_dir() )
	{
		return $arch->alt_compile_flags( check_sdl_dir() );
}
	else
	{
		#ask to download
		croak 'SDL not installed';
	}
}

1;

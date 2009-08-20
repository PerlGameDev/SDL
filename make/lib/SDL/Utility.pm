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
	return 0 if($^O eq 'MSWin32');

	`sdl-config --libs`;
	return 1 unless ($? >> 8) and return 0;
	
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
		chomp($_);
		return $_;
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
		chomp($_);
		return $_;
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

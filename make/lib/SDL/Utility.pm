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
use File::Spec;

#checks to see if sdl-config is availabe
#
sub sdl_con_found
{
       my $devnull = File::Spec->devnull();	
       `sdl-config --libs 2>$devnull`;
       return 1 unless ($? >> 8) and return 0;
}

#This should check if the folder actually has the SDL files
sub check_sdl_dir
{
	return 0 unless $ENV{SDL_INST_DIR} and return $ENV{SDL_INST_DIR};
}

sub not_installed_message
{
	print STDERR <<MSG;
********************************* !!!ERROR!!! ********************************* 
SDL library not found.
1) If you do not have SDL, you can download it from see http://www.libsdl.org/
2) If you have already installed SDL, you can specify the location of your SDL
   installation by setting the enviroment variable SDL_INST_DIR.  
*******************************************************************************
MSG
}


sub sdl_libs
{
	if(sdl_con_found)
	{
		my $devnull = File::Spec->devnull();
		local $_ = `sdl-config --libs 2>$devnull`; 
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
		not_installed_message;
		croak 'SDL not installed';
		return 0;
	}
}

sub sdl_c_flags
{
        if(sdl_con_found)
        {
		my $devnull = File::Spec->devnull();
		local $_  = `sdl-config --cflags 2>$devnull`;    
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
		not_installed_message ;
		croak 'SDL not installed';
	}
}

1;

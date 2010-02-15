package My::Utility;
use strict;
use warnings;
use Carp;


BEGIN{
	require Exporter;
	our @ISA = qw(Exporter);
	our @EXPORT_OK = qw(sdl_con_found sdl_libs sdl_c_flags); 
}
	my $has_alien = (eval { require Alien::SDL }) ? 1 : 0;

use lib '../';
#use SDL::Build;
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
	return Alien::SDL->config('libs');
}

sub sdl_c_flags
{
	return Alien::SDL->config('cflags');
}

sub sdl_shared_libs
{
	return Alien::SDL->config('shared_libs');
}

sub sdl_check_feature
{
	return Allien::SDL->check_feature(@_);
}

1;

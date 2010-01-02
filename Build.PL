#! perl -w
#
# Copyright (C) 2003 chromatic 
# Copyright (C) 2004 David J. Goehrig
# Copyright (C) 2009 Kartik Thakore

use strict;
use warnings;
use Carp;
use lib  'make/lib';

use Data::Dumper;
use SDL::Build;
use SDL::Utility;
use YAML;
use YAML::Node;

print STDERR <<BROKENWIN if ($^O =~ /bsd|solaris/i );
*************************** !!!WARNING!!! *****************************
BSD support is currently experimental - you can continue, but 
you've been warned! If you are interested in helping please contact us 
at sdl-devel\@perl.org, or join us on #sdl in irc.perl.org
***********************************************************************
BROKENWIN



my $sdl_compile_flags = SDL::Utility->sdl_c_flags();
my $sdl_link_flags    = SDL::Utility->sdl_libs();
# subsystem to build
#	file
#		location of source file => location of build file to get name right
#	libraries
#		name of shared library (soname)
#			preprocessor definition
#			name of header file
my %subsystems =
(
	SDL => {
		file      => {
			from  => 'src/SDL.xs',
			to    => 'lib/SDL_perl.xs',
		},
		libraries => [qw( SDL SDL_image SDL_mixer SDL_net SDL_ttf SDL_gfx
		                  png jpeg smpeg )],
	},
	Time => {
		file      => {
			from  => 'src/Core/Time.xs',
			to    => 'lib/SDL/Time.xs',
		},
		libraries => [qw( SDL )],
	},
	Events => {
		file      => {
			from  => 'src/Core/Events.xs',
			to    => 'lib/SDL/Events.xs',
		},
		libraries => [qw( SDL )],
	},
	Event => {
		file      => {
			from  => 'src/Core/objects/Event.xs',
			to    => 'lib/SDL/Event.xs',
		},
		libraries => [qw( SDL )],
	},
	BlitFunc => {
		file      => {
			from  => 'src/GFX/BlitFunc.xs',
			to    => 'lib/SDL/GFX/BlitFunc.xs',
		},
		libraries => [qw( SDL SDL_gfx_blitfunc )],
	},
	Framerate => {
		file      => {
			from  => 'src/GFX/Framerate.xs',
			to    => 'lib/SDL/GFX/Framerate.xs',
		},
		libraries => [qw( SDL SDL_gfx_framerate )],
	},
	FPSManager => {
		file      => {
			from  => 'src/GFX/FPSManager.xs',
			to    => 'lib/SDL/GFX/FPSManager.xs',
		},
		libraries => [qw( SDL SDL_gfx_framerate )],
	},
	ImageFilter => {
		file      => {
			from  => 'src/GFX/ImageFilter.xs',
			to    => 'lib/SDL/GFX/ImageFilter.xs',
		},
		libraries => [qw( SDL SDL_gfx_imagefilter )],
	},
	Primitives => {
		file      => {
			from  => 'src/GFX/Primitives.xs',
			to    => 'lib/SDL/GFX/Primitives.xs',
		},
		libraries => [qw( SDL SDL_gfx_primitives )],
	},
	Rotozoom => {
		file      => {
			from  => 'src/GFX/Rotozoom.xs',
			to    => 'lib/SDL/GFX/Rotozoom.xs',
		},
		libraries => [qw( SDL SDL_gfx_rotozoom )],
	},
	MultiThread => {
		file      => {
			from  => 'src/Core/MultiThread.xs',
			to    => 'lib/SDL/MultiThread.xs',
		},
		libraries => [qw( SDL )],
	},
	Video => {
		file      => {
			from  => 'src/Core/Video.xs',
			to    => 'lib/SDL/Video.xs',
		},
		libraries => [qw( SDL )],
	},
	Audio => {
		file      => {
			from  => 'src/Core/Audio.xs',
			to    => 'lib/SDL/Audio.xs',
		},
		libraries => [qw( SDL )],
	},
	Rect => {
		file      => {
			from  => 'src/Core/objects/Rect.xs',
			to    => 'lib/SDL/Rect.xs',
		},
		libraries => [qw( SDL )],
	},
	Color => {
		file      => {
			from  => 'src/Core/objects/Color.xs',
			to    => 'lib/SDL/Color.xs',
		},
		libraries => [qw( SDL )],
	},
	Surface => {
		file      => {
			from  => 'src/Core/objects/Surface.xs',
			to    => 'lib/SDL/Surface.xs',
		},
		libraries => [qw( SDL )],
	},
	Overlay => {
		file      => {
			from  => 'src/Core/objects/Overlay.xs',
			to    => 'lib/SDL/Overlay.xs',
		},
		libraries => [qw( SDL )],
	},
	RWOps => {
		file      => {
			from  => 'src/Core/objects/RWOps.xs',
			to    => 'lib/SDL/RWOps.xs',
		},
		libraries => [qw( SDL )],
	},

	PixelFormat => {
		file      => {
			from  => 'src/Core/objects/PixelFormat.xs',
			to    => 'lib/SDL/PixelFormat.xs',
		},
		libraries => [qw( SDL )],
	},
	AudioSpec => {
		file      => {
			from  => 'src/Core/objects/AudioSpec.xs',
			to    => 'lib/SDL/AudioSpec.xs',
		},
		libraries => [qw( SDL )],
	},
	AudioCVT => {
		file      => {
			from  => 'src/Core/objects/AudioCVT.xs',
			to    => 'lib/SDL/AudioCVT.xs',
		},
		libraries => [qw( SDL )],
	},
	Mixer => {
		file      => {
			from  => 'src/Mixer/Mixer.xs',
			to    => 'lib/SDL/Mixer.xs',
		},
		libraries => [qw( SDL SDL_mixer )],
	},
	MixChunk => {
		file      => {
			from  => 'src/Mixer/objects/MixChunk.xs',
			to    => 'lib/SDL/Mixer/MixChunk.xs',
		},
		libraries => [qw( SDL SDL_mixer )],
	},
	MixMusic => {
		file      => {
			from  => 'src/Mixer/objects/MixMusic.xs',
			to    => 'lib/SDL/Mixer/MixMusic.xs',
		},
		libraries => [qw( SDL SDL_mixer )],
	},
	Palette => {
		file      => {
			from  => 'src/Core/objects/Palette.xs',
			to    => 'lib/SDL/Palette.xs',
		},
		libraries => [qw( SDL )],
	},
	VideoInfo => {
		file      => {
			from  => 'src/Core/objects/VideoInfo.xs',
			to    => 'lib/SDL/VideoInfo.xs',
		},
		libraries => [qw( SDL )],
	},
	Mouse => {
		file      => {
			from  => 'src/Core/Mouse.xs',
			to    => 'lib/SDL/Mouse.xs',
		},
		libraries => [qw( SDL )],
	},
	Cursor => {
		file      => {
			from  => 'src/Core/objects/Cursor.xs',
			to    => 'lib/SDL/Cursor.xs',
		},
		libraries => [qw( SDL )],
	},
	Joystick => {
		file      => {
			from  => 'src/Core/Joystick.xs',
			to    => 'lib/SDL/Joystick.xs',
		},
		libraries => [qw( SDL )],
	},
	CDROM => {
		file      => {
			from  => 'src/Core/CDROM.xs',
			to    => 'lib/SDL/CDROM.xs',
		},
		libraries => [qw( SDL )],
	},
	CDTrack => {
		file      => {
			from  => 'src/Core/objects/CDTrack.xs',
			to    => 'lib/SDL/CDTrack.xs',
		},
		libraries => [qw( SDL )],
	},
	CD => {
		file      => {
			from  => 'src/Core/objects/CD.xs',
			to    => 'lib/SDL/CD.xs',
		},
		libraries => [qw( SDL )],
	},

	TTF_Font => {
		file      => {
			from  => 'src/TTF/objects/TTF_Font.xs',
			to    => 'lib/SDL/TTF_Font.xs',
		},
		libraries => [qw( SDL SDL_ttf )],
	},
	Version => {
		file      => {
			from  => 'src/Core/objects/Version.xs',
			to    => 'lib/SDL/Version.xs',
		},
		libraries => [qw( SDL )],
	},
	OpenGL => {
		file      => {
			from => 'src/OpenGL.xs',
			to   => 'lib/SDL/OpenGL.xs', 
		},
		libraries => [qw( SDL GL GLU )],
	},
	SFont => {
		file	=> {
			from => 'src/SFont.xs',
			to   =>	'lib/SDL/SFont.xs',
		},
		libraries => [qw( SDL SDL_ttf )],
	},	
	Image => {
		file	=> {
			from => 'src/Image.xs',
			to   =>	'lib/SDL/Image.xs',
		},
		libraries => [qw( SDL SDL_image )],
	},	
	Net => {
		file      => {
			from  => 'src/Net/Net.xs',
			to    => 'lib/SDL/Net.xs',
		},
		libraries => [qw( SDL SDL_net )],
	},
	TCP => {
		file      => {
			from  => 'src/Net/TCP.xs',
			to    => 'lib/SDL/Net/TCP.xs',
		},
		libraries => [qw( SDL SDL_net )],
	},
	UDP => {
		file      => {
			from  => 'src/Net/UDP.xs',
			to    => 'lib/SDL/Net/UDP.xs',
		},
		libraries => [qw( SDL SDL_net )],
	},

	IPaddress => {
		file      => {
			from  => 'src/Net/objects/IPaddress.xs',
			to    => 'lib/SDL/Net/IPaddress.xs',
		},
		libraries => [qw( SDL SDL_net )],
	},

);

my %libraries = (
	SDL         => {
		define => 'HAVE_SDL', 
		header => 'SDL.h',
	},
	SDL_image   => {
		define => 'HAVE_SDL_IMAGE',   
		header => 'SDL_image.h'
	},
	SDL_mixer   => {
		define => 'HAVE_SDL_MIXER',   
		header => 'SDL_mixer.h'
	},
	SDL_net     => {
		define => 'HAVE_SDL_NET',     
		header => 'SDL_net.h'
	},
	SDL_ttf     => {
		define => 'HAVE_SDL_TTF',     
		header => 'SDL_ttf.h'
	},
	SDL_gfx     => {
		define => 'HAVE_SDL_GFX',     
		header => 'SDL_gfxPrimitives.h'
	},
	SDL_gfx_blitfunc    => {
		define => 'HAVE_SDL_GFX_BLITFUNC',     
		header => 'SDL_gfxBlitFunc.h'
	},
	SDL_gfx_framerate   => {
		define => 'HAVE_SDL_GFX_FRAMERATE',     
		header => 'SDL_framerate.h'
	},
	SDL_gfx_imagefilter => {
		define => 'HAVE_SDL_GFX_IMAGEFILTER',     
		header => 'SDL_imageFilter.h'
	},
	SDL_gfx_primitives  => {
		define => 'HAVE_SDL_GFX_PRIMITIVES',     
		header => 'SDL_gfxPrimitives.h'
	},
	SDL_gfx_rotozoom    => {
		define => 'HAVE_SDL_GFX_ROTOZOOM',     
		header => 'SDL_rotozoom.h'
	},
	png         => {
		define    => 'HAVE_PNG',
		header    => 'png.h',
	},
	jpeg        => {	
		define    => 'HAVE_JPEG',
		header    => 'jpeglib.h',
	},
	smpeg       => {
		define    => 'HAVE_SMPEG',
		header    => 'smpeg.h',
	},
	GL          => {
		define => 'HAVE_GL',  
		header => 'gl.h'
	},
	GLU         => {
		define => 'HAVE_GLU', 
		header => 'glu.h'
	},
);

# need the platform-specific module to find include paths correctly
# see build/lib/SDL/Build/*pm
my $arch          = SDL::Build->get_arch( $^O );

# see which subsystems can be built -- do we have headers for them?
my $build_systems = $arch->find_subsystems( \%subsystems, \%libraries );
# This is called in make/lib/SDL/Build.pm as it is the base of arch


# now write SDL::Config
$arch->write_sdl_config( $build_systems );

# and fetch all of the information needed to compile
my $defines       = $arch->build_defines( \%libraries, $build_systems );
my $includes      = $arch->build_includes( \%libraries, $build_systems);
my $links         = $arch->build_links( \%libraries, $build_systems );


# mangle the compilable files into a format Module::Build can understand
my %xs = map { $subsystems{$_}{file}{from} => $subsystems{$_}{file}{to} }
	     keys %subsystems;
my $build   = SDL::Build->new(
	module_name          => 'SDL',
	dist_name            => 'SDL', 
	license		     => 'lgpl',
	dist_version_from    => 'lib/SDL.pm',
	configure_requires	      =>
	{
		'YAML'	=> '0.68',
		'ExtUtils::CBuilder' => '0.260301',
		'Alien::SDL' => '0.07.2',
	},
	build_requires =>
	{
		'Test::Simple' => '0.88',
		'IO::CaptureOutput' => '0',
		'Test::Most' => '0.21',
	},
	build_recommends     =>
	{
		'Pod::ToDemo'  => '0.20'		
	},
	c_source	     => 'src',
	xs_files             => \%xs,
	meta_add	     =>	     
	{
		no_index =>  { file => [ <make/lib/SDL/*.pm>, <make/lib/SDL/Build/*.pm>, <make/lib/ExtUtils/CBuilder/*>, <make/lib/ExtUtils/*>, <make/lib/ExtUtils/CBuilder/Platform/Windows.pm> ] },
	},
	dist_abstract => 'SDL bindings to Perl',
	dist_author	     => 'Kartik Thakore <KTHAKORE@cpan.org>',
);

if($arch eq 'Darwin')
{
	$build->{c_source} = $arch->build_c_source( \%libraries, $build_systems );
	$build->{c_sources} = $arch->build_c_sources( \%libraries, $build_systems );
	$build->{install_base} = $arch->build_install_base( \%libraries, $build_systems );

}

# and here's where the real (and ugly) magic works... see SDL::Build

$build->set_flags(
	\%subsystems,
	$build_systems,
	$defines,
	$includes,
	$links,
	$sdl_compile_flags,
	$sdl_link_flags,
);
# now we're ready to go!
$build->create_build_script();

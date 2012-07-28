#!/usr/bin/perl
use warnings;
use strict;

use SDL;
use SDLx::App;
use SDL::Surface;
use SDL::Event;
use SDL::Image;
use SDL::Color;
use Data::Dumper;

use OpenGL qw(:all);

my $app; #sdl window
my $sdl_timer;
my $event;

package main;
init_SDL();

while (1) {
	pump_sdl();

}

###################################################

sub init_SDL {
	$app = SDLx::App->new( w => 1024, h => 768, d => 16, gl => 1 );

	print "Initializing OpenGL settings\n";
	printf "%-24s%s\n", "GL_RED_SIZE ",     $app->attribute( SDL_GL_RED_SIZE() );
	printf "%-24s%s\n", "GL_GREEN_SIZE ",   $app->attribute( SDL_GL_GREEN_SIZE() );
	printf "%-24s%s\n", "GL_BLUE_SIZE ",    $app->attribute( SDL_GL_BLUE_SIZE() );
	printf "%-24s%s\n", "GL_DEPTH_SIZE ",   $app->attribute( SDL_GL_DEPTH_SIZE() );
	printf "%-24s%s\n", "GL_DOUBLEBUFFER ", $app->attribute( SDL_GL_DOUBLEBUFFER() );

	#glEnable(GL_CULL_FACE);
	#glFrontFace(GL_CCW);
	#glCullFace(GL_BACK);

	InitView();
	DrawScene();
	$app->sync();

	$event = new SDL::Event;

}
#######################################################
sub pump_sdl {

	SDL::Events::pump_events();

	while ( SDL::Events::poll_event($event) ) {
		my $type = $event->type(); # get event type
		exit if $type == SDL_QUIT;
	}
	DrawScene();

	return 1;
}
#######################################################
sub DrawScene {

	glClear( GL_DEPTH_BUFFER_BIT() | GL_COLOR_BUFFER_BIT() );

	glLoadIdentity();

	glTranslatef( 0, 0, -6.0 );
	glColor3d( 1, 1, 1 );

	glBegin(GL_QUADS);
	glTexCoord2f( 0.0, 0.0 );
	glVertex3f( -1.0, 1.0, 0 );
	glTexCoord2f( 1.0, 0.0 );
	glVertex3f( 1.0, 1.0, 0 );
	glTexCoord2f( 1.0, 1.0 );
	glVertex3f( 1.0, -1.0, 0 );
	glTexCoord2f( 0.0, 1.0 );
	glVertex3f( -1.0, -1.0, 0 );
	glEnd();

	$app->sync();
}

sub InitView {
	my $width  = 1024;
	my $height = 800;

	glClearColor( 0.0, 0.0, 0.0, 0.0 );
	glShadeModel(GL_SMOOTH);
	glClearDepth(1.0);
	glDisable(GL_DEPTH_TEST);
	glBlendFunc( GL_SRC_ALPHA, GL_ONE );
	glEnable(GL_BLEND);

	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );

	glEnable(GL_TEXTURE_2D);

	LoadTexture();

	glViewport( 0, 0, 1024, 768 );
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective( 45.0, $width / $height, 1.0, 100.0 );

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

sub LoadTexture {
	my $surface;
	my $nOfColors;
	my $texture_format;
	my $texture = 0;
	my $img = $ARGV[0] || 'test/data/picture.bmp';

	$surface = SDL::Image::load($img);
	die "Couldn't load image: " . SDL::get_error() unless $surface;
	SDL::Video::lock_surface($surface);

	#get the number of channels in the SDL surface
	$nOfColors = $surface->format->BytesPerPixel;
	if ( $nOfColors == 4 ) # contains an alpha channel
	{
		if ( $surface->format->Rmask == 0x000000ff ) {
			$texture_format = GL_RGBA;
		} else {
			$texture_format = GL_BGRA;
		}
	} elsif ( $nOfColors == 3 ) # no alpha channel
	{
		if ( $surface->format->Rmask == 0x000000ff ) {
			$texture_format = GL_RGB;
		} else {
			$texture_format = GL_BGR;
		}
	} else {
		print "warning: the image is not truecolor..  this will 
probably break\n";
	}

	# Have OpenGL generate a texture object handle for us
	glGenTextures_p(1);

	# Bind the texture object
	glBindTexture( GL_TEXTURE_2D, 1 );

	#Set the texture's stretching properties
	glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

	# Edit the texture object's image data using the information SDL_Surface gives us

	gluBuild2DMipmaps_s( GL_TEXTURE_2D, $surface->format->BytesPerPixel,
		$surface->w, $surface->h, $texture_format, GL_UNSIGNED_BYTE,
		${ $surface->get_pixels_ptr }
	);

}

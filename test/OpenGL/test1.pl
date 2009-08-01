#!/usr/bin/env perl

use SDL;
use SDL::App;
use SDL::Surface;
use SDL::Event;
use SDL::OpenGL;
use SDL::OpenGL::Constants;

#for ( keys %main:: ) {
#	print "$_\n";
#}

print "Starting $0\n";

my $app = new SDL::App	-w => 800, -h => 600, -d => 16, -gl => 1;

print "Initializing OpenGL settings\n";
printf "%-24s%s\n", "GL_RED_SIZE ", $app->attribute( SDL_GL_RED_SIZE() );
printf "%-24s%s\n", "GL_GREEN_SIZE ", $app->attribute( SDL_GL_GREEN_SIZE());
printf "%-24s%s\n", "GL_BLUE_SIZE ", $app->attribute( SDL_GL_BLUE_SIZE() );
printf "%-24s%s\n", "GL_DEPTH_SIZE ", $app->attribute( SDL_GL_DEPTH_SIZE() );
printf "%-24s%s\n", "GL_DOUBLEBUFFER ", $app->attribute( SDL_GL_DOUBLEBUFFER() );

sub DrawScene {

	glClear( GL_DEPTH_BUFFER_BIT() 
		| GL_COLOR_BUFFER_BIT());

	glLoadIdentity();

	glTranslate(-1.5,0,-6);
	
	glColor(1,1,1);

	glBegin(GL_TRIANGLES());
		glColor(1,0,0) if (@_);
		glVertex(0,1,0);
		glColor(0,1,0) if (@_);
		glVertex(-1,-1,0);
		glColor(0,0,1) if (@_);
		glVertex(1,-1,0);
	glEnd();

	glTranslate(3,0,0);

	glBegin(GL_QUADS());
		glColor(1,0,0) if (@_);
		glVertex(-1,1,0);
		glColor(0,1,0) if (@_);
		glVertex(1,1,0);
		glColor(0,0,1) if (@_);
		glVertex(1,-1,0);
		glColor(1,1,0) if (@_);
		glVertex(-1,-1,0);
	glEnd();
}

sub DrawColorScene {
	DrawScene 'with color';
}

sub InitView {
	glViewport(0,0,800,600);

	glMatrixMode(GL_PROJECTION());
	glLoadIdentity();

	if ( @_ ) {
		gluPerspective(45.0,4/3,0.1,100.0);
	} else {
		glFrustum(-0.1,0.1,-0.075,0.075,0.175,100.0);
	}

	glMatrixMode(GL_MODELVIEW());
	glLoadIdentity();
}

InitView();

DrawScene();

$app->sync();

$toggle = 1;

$app->loop( { 
	SDL_QUIT() => sub { exit(0); },
	SDL_KEYDOWN() => sub { 	$toggle = ($toggle) ? 0 : 1; 
				($toggle) ? DrawScene() : DrawColorScene(); 
				$app->sync();
				},
	} );

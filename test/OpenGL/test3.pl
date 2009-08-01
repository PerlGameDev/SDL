#!/usr/bin/env perl
#
# Bezier Curve example 
#

use SDL;
use SDL::App;
use SDL::Surface;
use SDL::Event;
use SDL::OpenGL;

my $app = new SDL::App	-w => 800, -h => 600, -d => 16, -gl => 1;

my @points = (  [-4.0, -4.0,  0.0 ],
		[-2.0,  4.0,  0.0 ],
		[ 2.0, -4.0,  0.0 ],
		[ 4.0,  4.0,  0.0 ] );

my $ctrlpoints = pack "d12", map { @$_ } @points;

sub init {
	
	glViewport(0,0,800,600);
	glMatrixMode(GL_PROJECTION());
	glLoadIdentity();

	glFrustum (-0.1,0.1,-0.075,0.075,0.3,100.0 );
	
	glMatrixMode(GL_MODELVIEW());
	glLoadIdentity();
	
	glTranslate(0,0,-30);

	glClearColor(0.0, 0.0, 0.0, 0.0);	
	glShadeModel(GL_FLAT());
	glMap1(GL_MAP1_VERTEX_3(), 0.0, 1.0, 3, 4, $ctrlpoints);
	glEnable(GL_MAP1_VERTEX_3());
}

sub display {
	glClear(GL_COLOR_BUFFER_BIT);
	glColor(1.0,1.0,1.0);
	glBegin(GL_LINE_STRIP);
		for my $i ( 0 .. 30 ) {
			glEvalCoord1($i/30);
		}
	glEnd();

	glPointSize(5);
	glColor(1.0,1.0,0);
	glBegin(GL_POINTS);
		for my $i ( 0 .. 3 ) {
			glVertex( @{$points[$i]} );
		}
	glEnd();
	$app->sync();
}

init();
display();

$app->loop({ SDL_QUIT() => sub { exit(); } });


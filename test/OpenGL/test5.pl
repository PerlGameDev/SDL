#!/usr/bin/env perl
#
# Bezier Surface example 
#

use SDL;
use SDL::App;
use SDL::Event;
use SDL::OpenGL;

my $app = new SDL::App	-w => 800, -h => 600, -d => 16, -gl => 1;

my $knots = pack "f8", 0,0,0,0,1,1,1,1;
my $edgePts = pack "f10", 0,0,1,0,1,1,0,1,0,0;
my $curvePts = pack "f8", 0.25,0.5,0.25,0.75,0.75,0.75,0.75,0.5;
my $curveKnots = pack "f8", 0,0,0,0,1,1,1,1;
my $pwlPts = pack "f8", 0.75, 0.5, 0.5, 0.25, 0.25, 0.5, 0, 0;

sub init {
	glViewport(0,0,800,600);
	glMatrixMode(GL_PROJECTION());
	glLoadIdentity();
	glFrustum (-0.1,0.1,-0.075,0.075,0.3,100.0 );
	glMatrixMode(GL_MODELVIEW());
	glLoadIdentity();
	glTranslate(0,0,-15);
	glClearColor(0.0, 0.0, 0.0, 0.0);	
	glShadeModel(GL_SMOOTH());
}

sub initlight {
	glEnable(GL_LIGHTING());
	glEnable(GL_LIGHT0());
	glEnable(GL_DEPTH_TEST());
	glEnable(GL_AUTO_NORMAL());
	glEnable(GL_NORMALIZE());
	glLight(GL_LIGHT0(),GL_AMBIENT(),0.3,0.3,0.3,1.0);
	glLight(GL_LIGHT0(),GL_POSITION(), 1.0,0.0,2.0,1.0);
	glMaterial(GL_FRONT(), GL_DIFFUSE(),0.6,0.6,0.6,1.0);
	glMaterial(GL_FRONT(), GL_SPECULAR(), 1.0, 1.0, 1.0, 1.0);
	glMaterial(GL_FRONT(), GL_SHININESS(), 40.0);
}

my ($a,$b) = (0,90);

my $ctrldata;
sub initpts {
	my @points;
	for my $u ( 0 .. 3 ) {
		for my $v ( 0 .. 3 ) {
			push @points, 2.0 * ($u - 1.5);
			push @points, 2.0 * ($v - 1.5);
			if (( $u == 1 || $u == 2 ) && ( $v == 1 || $v == 2 )) {
				push @points,  3.0;
			} else {
				push @points, -3.0;
			}
		}
	}
	$ctrldata = pack "f48", @points;
}

sub display {
	glClear(GL_COLOR_BUFFER_BIT() | GL_DEPTH_BUFFER_BIT());
	glPushMatrix();
	glRotate($a%360,0,1,0);
	glRotate($b%360,-1,0,0);
	glScale(0.5,0.5,0.5);
	$nurb = gluNewNurbsRenderer();
	gluNurbsProperty($nurb,GLU_CULLING,GL_TRUE);
	gluBeginSurface($nurb);
		gluNurbsSurface($nurb, 8, $knots, 8, $knots, 
			4*3, 3, $ctrldata, 
			4, 4, GL_MAP2_VERTEX_3);
	if ($toggle) {
		gluBeginTrim($nurb);
			gluPwlCurve($nurb,5,$edgePts,2,GLU_MAP1_TRIM_2);
		gluEndTrim($nurb);
		gluBeginTrim($nurb);
			gluNurbsCurve($nurb,8,$curveKnots, 2, $curvePts, 4, GLU_MAP1_TRIM_2);
			gluPwlCurve($nurb,3,$pwlPts,2,GLU_MAP1_TRIM_2);
		gluEndTrim($nurb);
	}
		
	gluEndSurface($nurb);

	glPopMatrix();
	$app->sync();
}

init();
initlight();
initpts();
display();

print STDERR <<USAGE;
Press:
q			Quit
t 			Toggle Curve & Trim
f			Toggle Fullscreen
Up/Down/Left/Right	Rotate

USAGE

my $event = new SDL::Event;
$app->loop ({
		SDL_QUIT() => sub { exit(); }, 
		SDL_KEYDOWN() => sub { 
			my ($event) = @_;
			if ( $event->key_sym() == SDLK_f ) {
				$app->fullscreen();
				display(); 
			} elsif ( $event->key_sym() == SDLK_t ) {
				$toggle = $toggle ? 0 : 1;
				display();
			} elsif ( $event->key_sym() == SDLK_q ) {
				exit();
			} else {
				if ($event->key_sym() == SDLK_LEFT()) {
					$a -= 10; 
				} elsif ($event->key_sym() == SDLK_RIGHT()) {
					$a += 10; 
				} elsif ($event->key_sym() == SDLK_UP()) {
					$b += 10;
				} elsif ($event->key_sym() == SDLK_DOWN()) {
					$b -= 10;	
				}
				display(); 
			}
		},
});


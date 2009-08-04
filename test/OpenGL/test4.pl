#!/usr/bin/env perl
#
# Bezier Surface example 
#

use SDL;
use SDL::App;
use SDL::Event;
use SDL::OpenGL;

my $app = new SDL::App	-w => 800, -h => 600, -d => 16, -gl => 1;

my @points = (  [-1.5, -1.5,  4.0 ], [-0.5, -1.5,  2.0 ],
		[-0.5, -1.5, -1.0 ], [ 1.5, -1.5,  2.0 ],
		[-1.5, -0.5,  1.0 ], [-0.5, -0.5,  3.0 ],
		[ 0.5, -0.5,  0.0 ], [ 1.5, -0.5, -1.0 ], 
		[-1.5,  0.5,  4.0 ], [-0.5,  0.5,  0.0 ],
		[ 0.5,  0.5,  3.0 ], [ 1.5,  0.5,  4.0 ],
		[-1.5,  1.5, -2.0 ], [-0.5,  1.5, -2.0 ],
		[ 0.5,  1.5,  0.0 ], [ 1.5,  1.5, -1.0 ],
	);

my $ctrlpoints = pack "d48", map { @$_ } @points;

sub init {
	
	glViewport(0,0,800,600);
	glMatrixMode(GL_PROJECTION());
	glLoadIdentity();

	glFrustum (-0.1,0.1,-0.075,0.075,0.3,100.0 );
	
	glMatrixMode(GL_MODELVIEW());
	glLoadIdentity();
	
	glTranslate(0,0,-15);

	glClearColor(0.0, 0.0, 0.0, 0.0);	
	glMap2(GL_MAP2_VERTEX_3(), 0, 1, 3, 4, 0, 1, 12, 4, $ctrlpoints);
	glEnable(GL_MAP2_VERTEX_3());
	glMapGrid2(20,0,1,20,0,1);
	glEnable(GL_DEPTH_TEST);
	glShadeModel(GL_SMOOTH());
}

sub initlight {

	glEnable(GL_LIGHTING());
	glEnable(GL_LIGHT0());

	glLight(GL_LIGHT0(),GL_AMBIENT(),0.2,0.2,0.2,1.0);
	glLight(GL_LIGHT0(),GL_POSITION(), 0.0,0.0,2.0,1.0);

	glMaterial(GL_FRONT(), GL_DIFFUSE(),0.6,0.6,0.6,1.0);
	glMaterial(GL_FRONT(), GL_SPECULAR(), 1.0, 1.0, 1.0, 1.0);
	glMaterial(GL_FRONT(), GL_SHININESS(), 50.0);

}

my ($a1,$a2) = (89,305);

sub display {
	glClear(GL_COLOR_BUFFER_BIT() | GL_DEPTH_BUFFER_BIT());
	glColor(1.0,1.0,1.0);
	glPushMatrix();
	glRotate($a1 % 360, 0.0, 1.0, 1.0);
	glRotate($a2 % 360, 1.0, 1.0, 0.0);
	if ($toggle) {
		glEvalMesh2(GL_FILL,0,20,0,20);
	} else {
		glBegin(GL_LINE_STRIP);
		for my $j ( 0 .. 8 ) {
			for my $i ( 0 .. 30 ) {
				glEvalCoord2($i/30,$j/8);
			}
			for my $i ( 0 .. 30 ) {
				glEvalCoord2($j/8,$i/30);
			}
		}
		glEnd();
	}
	glPopMatrix();
	$app->sync();
}

print STDERR <<USAGE;
$0
	Press:	t 	Toggle wireframe / solid
		f 	Toggle fullscreen
		q	Quit
		any	Rotate Bezier Surface
USAGE

init();
initlight();
display();

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
				$a1 += 33; $a2 += 5;  
				display(); 
			}
		},
});


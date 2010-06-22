use strict;
use warnings;
use SDL;
use SDLx::App;
use SDL::Mouse;
use SDL::Video;
use SDL::Events;
use SDL::Event;
use OpenGL qw(:all);

my ($SDLAPP, $WIDTH, $HEIGHT, $SDLEVENT);

$| = 1;
$WIDTH = 1024;
$HEIGHT = 768;
$SDLAPP = SDLx::App->new(-title => "Opengl App", -width => $WIDTH, -height => $HEIGHT, -gl => 1);
$SDLEVENT = SDL::Event->new;


glEnable(GL_DEPTH_TEST);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(60, $WIDTH / $HEIGHT, 1, 1000);
glTranslatef(0, 0, -20);


while (1) {
  &handlepolls;
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glRotatef(.1, 1, 1, 1);
  &drawscene;
  $SDLAPP->sync;
}



sub drawscene {
  my ($color, $x, $y, $z);

  for (-2 .. 2) {
    glPushMatrix;
    glTranslatef($_ * 3, 0, 0);
    glColor3d(1, 0, 0);
    &draw_cube;
    glPopMatrix;
  }

  return "";
}





sub draw_cube {
  my (@indices, @vertices, $face, $vertex, $index, $coords);

  @indices = qw(4 5 6 7   1 2 6 5   0 1 5 4
                0 3 2 1   0 4 7 3   2 3 7 6);
  @vertices = ([-1, -1, -1], [ 1, -1, -1],
               [ 1,  1, -1], [-1,  1, -1],
               [-1, -1,  1], [ 1, -1,  1],
               [ 1,  1,  1], [-1,  1,  1]);

  glBegin(GL_QUADS);

  foreach my $face (0..5) {
    foreach my $vertex (0..3) {
      $index  = $indices[4 * $face + $vertex];
      $coords = $vertices[$index];
      
      glVertex3d(@$coords);
    }
  }

  glEnd;

  return "";
}




sub handlepolls {
  my ($type, $key);

  SDL::Events::pump_events();

  while (SDL::Events::poll_event($SDLEVENT)) {
    $type = $SDLEVENT->type();
    $key = ($type == 2 or $type == 3) ? $SDLEVENT->key_sym : "";

    if ($type == 4) { printf("You moved the mouse! x=%s y=%s xrel=%s yrel=%s\n", $SDLEVENT->motion_x, $SDLEVENT->motion_y, $SDLEVENT->motion_xrel, $SDLEVENT->motion_yrel) }
    elsif ($type == 2) { print "You are pressing $key\n" }
    elsif ($type == 3) { print "You released $key\n" }
    elsif ($type == 12) { exit }
    else { print "TYPE $type UNKNOWN!\n" }

    if ($type == 2) {
      if ($key eq "q" or $key eq "escape") { exit }
    }
  }

  return "";
}

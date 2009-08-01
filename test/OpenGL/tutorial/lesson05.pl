#!/usr/bin/perl 
# This code was created by Jeff Molofee '99
# (ported to SDL by Sam Lantinga '2000)
# (ported to Perl/SDL by Wayne Keenan '2000)
#
# If you've found this code useful, please let me know.
#
# Visit me at www.demonews.com/hosted/nehe 

use strict;
use Getopt::Long;

use SDL;
use SDL::App;
use SDL::OpenGL;
use SDL::Event;
use SDL::Cursor;     

my $arg_screen_width =640;
my $arg_screen_height=512;
my $arg_fullscreen=0;
my $delay = 30;

GetOptions(
	   "width:i"        => \$arg_screen_width,
	   "height:i"       => \$arg_screen_height,
	   "fullscreen!"    => \$arg_fullscreen,
	   "delay:i"	    => \$delay,
	  ) or die $!;

main();
exit;


sub main
  {  
   my $done=0;
   
   my $app = new SDL::App ( -title => "Jeff Molofee's GL Code Tutorial ... NeHe '99", 
			    -icon => "icon.png",
			    -width => $arg_screen_width,
			    -height =>$arg_screen_height,
			    -opengl => 1,
			  );

	$app->fullscreen if ($arg_fullscreen);
   
   SDL::ShowCursor(0);   
   
   my $event = new SDL::Event;
   $event->set(SDL_SYSWMEVENT(),SDL_IGNORE());#
   
   InitGL($arg_screen_width, $arg_screen_height);

   while ( ! $done ) {

    DrawGLScene();

    $app->sync();
    $app->delay($delay);
   
    $event->pump;
    $event->poll;
    
    
    if ( $event->type == SDL_QUIT() ) {
     $done = 1;
    }

    if ( $event->type == SDL_KEYDOWN() ) {
     if ( $event->key_sym == SDLK_ESCAPE() ) {
      $done = 1;
     }
    }
   }
  }






#########################################################################
#Pretty much in original form, but 'Perlised' 



#/* rotation angle for the triangle. */
my $rtri = 0.0;

#/* rotation angle for the quadrilateral. */
my $rquad = 0.0;


sub InitGL
  {
   my ($Width, $Height)=@_;

   glViewport(0, 0, $Width, $Height);
   glClearColor(0.0, 0.0, 0.0, 0.0);				# This Will Clear The Background Color To Black
   glClearDepth(1.0);						# Enables Clearing Of The Depth Buffer
   glDepthFunc(GL_LESS);					# The Type Of Depth Test To Do
   glEnable(GL_DEPTH_TEST);					# Enables Depth Testing
   glShadeModel(GL_SMOOTH);					# Enables Smooth Color Shading
   
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();						# Reset The Projection Matrix
   
   gluPerspective(45.0, $Width/$Height, 0.1, 100.0);		# Calculate The Aspect Ratio Of The Window
   
   glMatrixMode(GL_MODELVIEW);
  }



# The main drawing function.
sub DrawGLScene
  {
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		# Clear The Screen And The Depth Buffer
   glLoadIdentity();						# Reset The View
   
  glTranslate(-1.5,0.0,-6.0);		# Move Left 1.5 Units And Into The Screen 6.0
	
  glRotate($rtri,0.0,1.0,0.0);		# Rotate The Pyramid On The Y axis 

  # draw a pyramid (in smooth coloring mode)
  glBegin(GL_POLYGON);				# start drawing a pyramid

  # front face of pyramid
  glColor(1.0,0.0,0.0);			# Set The Color To Red
  glVertex(0.0, 1.0, 0.0);		        # Top of triangle (front)
  glColor(0.0,1.0,0.0);			# Set The Color To Green
  glVertex(-1.0,-1.0, 1.0);		# left of triangle (front)
  glColor(0.0,0.0,1.0);			# Set The Color To Blue
  glVertex(1.0,-1.0, 1.0);		        # right of traingle (front)	

  # right face of pyramid
  glColor(1.0,0.0,0.0);			# Red
  glVertex( 0.0, 1.0, 0.0);		# Top Of Triangle (Right)
  glColor(0.0,0.0,1.0);			# Blue
  glVertex( 1.0,-1.0, 1.0);		# Left Of Triangle (Right)
  glColor(0.0,1.0,0.0);			# Green
  glVertex( 1.0,-1.0, -1.0);		# Right Of Triangle (Right)

  # back face of pyramid
  glColor(1.0,0.0,0.0);			# Red
  glVertex( 0.0, 1.0, 0.0);		# Top Of Triangle (Back)
  glColor(0.0,1.0,0.0);			# Green
  glVertex( 1.0,-1.0, -1.0);		# Left Of Triangle (Back)
  glColor(0.0,0.0,1.0);			# Blue
  glVertex(-1.0,-1.0, -1.0);		# Right Of Triangle (Back)

  # left face of pyramid.
  glColor(1.0,0.0,0.0);			# Red
  glVertex( 0.0, 1.0, 0.0);		# Top Of Triangle (Left)
  glColor(0.0,0.0,1.0);			# Blue
  glVertex(-1.0,-1.0,-1.0);		# Left Of Triangle (Left)
  glColor(0.0,1.0,0.0);			# Green
  glVertex(-1.0,-1.0, 1.0);		# Right Of Triangle (Left)

  glEnd();					# Done Drawing The Pyramid

  glLoadIdentity();				# make sure we're no longer rotated.
  glTranslate(1.5,0.0,-7.0);		# Move Right 3 Units, and back into the screen 7
	
  glRotate($rquad,1.0,1.0,1.0);		# Rotate The Cube On X, Y, and Z

  # draw a cube (6 quadrilaterals)
  glBegin(GL_QUADS);				# start drawing the cube.
  
  # top of cube
  glColor(0.0,1.0,0.0);			# Set The Color To Blue
  glVertex( 1.0, 1.0,-1.0);		# Top Right Of The Quad (Top)
  glVertex(-1.0, 1.0,-1.0);		# Top Left Of The Quad (Top)
  glVertex(-1.0, 1.0, 1.0);		# Bottom Left Of The Quad (Top)
  glVertex( 1.0, 1.0, 1.0);		# Bottom Right Of The Quad (Top)

  # bottom of cube
  glColor(1.0,0.5,0.0);			# Set The Color To Orange
  glVertex( 1.0,-1.0, 1.0);		# Top Right Of The Quad (Bottom)
  glVertex(-1.0,-1.0, 1.0);		# Top Left Of The Quad (Bottom)
  glVertex(-1.0,-1.0,-1.0);		# Bottom Left Of The Quad (Bottom)
  glVertex( 1.0,-1.0,-1.0);		# Bottom Right Of The Quad (Bottom)

  # front of cube
  glColor(1.0,0.0,0.0);			# Set The Color To Red
  glVertex( 1.0, 1.0, 1.0);		# Top Right Of The Quad (Front)
  glVertex(-1.0, 1.0, 1.0);		# Top Left Of The Quad (Front)
  glVertex(-1.0,-1.0, 1.0);		# Bottom Left Of The Quad (Front)
  glVertex( 1.0,-1.0, 1.0);		# Bottom Right Of The Quad (Front)

  # back of cube.
  glColor(1.0,1.0,0.0);			# Set The Color To Yellow
  glVertex( 1.0,-1.0,-1.0);		# Top Right Of The Quad (Back)
  glVertex(-1.0,-1.0,-1.0);		# Top Left Of The Quad (Back)
  glVertex(-1.0, 1.0,-1.0);		# Bottom Left Of The Quad (Back)
  glVertex( 1.0, 1.0,-1.0);		# Bottom Right Of The Quad (Back)

  # left of cube
  glColor(0.0,0.0,1.0);			# Blue
  glVertex(-1.0, 1.0, 1.0);		# Top Right Of The Quad (Left)
  glVertex(-1.0, 1.0,-1.0);		# Top Left Of The Quad (Left)
  glVertex(-1.0,-1.0,-1.0);		# Bottom Left Of The Quad (Left)
  glVertex(-1.0,-1.0, 1.0);		# Bottom Right Of The Quad (Left)

  # Right of cube
  glColor(1.0,0.0,1.0);			# Set The Color To Violet
  glVertex( 1.0, 1.0,-1.0);	        # Top Right Of The Quad (Right)
  glVertex( 1.0, 1.0, 1.0);		# Top Left Of The Quad (Right)
  glVertex( 1.0,-1.0, 1.0);		# Bottom Left Of The Quad (Right)
  glVertex( 1.0,-1.0,-1.0);		# Bottom Right Of The Quad (Right)
  glEnd();					# Done Drawing The Cube

  $rtri+=15.0;					# Increase The Rotation Variable For The Triangle
  $rquad-=15.0;					# Decrease The Rotation Variable For The Quad 
 
   
  }





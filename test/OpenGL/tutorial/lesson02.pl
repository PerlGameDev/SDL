#!/usr/bin/perl -w
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

my $arg_screen_width =640;
my $arg_screen_height=512;
my $arg_fullscreen=0;

GetOptions(
	   "width:i"        => \$arg_screen_width,
	   "height:i"       => \$arg_screen_height,
	   "fullscreen!"    => \$arg_fullscreen,

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
			    -d => 16,
			    -gl => 1,
			    
			  );
	$app->fullscreen() if ($arg_fullscreen);
   
   SDL::ShowCursor (0);   
   
   my $event = new SDL::Event;
   $event->set(SDL_SYSWMEVENT,SDL_IGNORE);#

   InitGL($arg_screen_width, $arg_screen_height);

   while ( ! $done ) {

    DrawGLScene();

    $app->sync();
   
    $event->pump;
    $event->poll;
    
    
    if ( $event->type == SDL_QUIT ) {
     $done = 1;
    }

    if ( $event->type == SDL_KEYDOWN ) {
     if ( $event->key_sym == SDLK_ESCAPE ) {
      $done = 1;
     }
    }
   }
  }






#########################################################################
#Pretty much in original form, but 'Perlised' 


sub InitGL
  {
   my ($Width, $Height)=@_;

   glViewport(0, 0, $Width, $Height);
   glClearColor(0.0, 0.0, 0.0, 0.0);				# This Will Clear The Background Color To Black
   glClearDepth(1.0);						# Enables Clearing Of The Depth Buffer
   glDepthFunc(GL_LESS());					# The Type Of Depth Test To Do
   glEnable(GL_DEPTH_TEST());					# Enables Depth Testing
   glShadeModel(GL_SMOOTH());					# Enables Smooth Color Shading
   
   glMatrixMode(GL_PROJECTION());
   glLoadIdentity();						# Reset The Projection Matrix
   
   gluPerspective(45.0, $Width/$Height, 0.1, 100.0);		# Calculate The Aspect Ratio Of The Window
   
   glMatrixMode(GL_MODELVIEW());
  }



# The main drawing function.
sub DrawGLScene
  {
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		# Clear The Screen And The Depth Buffer
   glLoadIdentity();						# Reset The View
   
   glTranslate(-1.5,0.0,-6.0);					# Move Left 1.5 Units And Into The Screen 6.0
   
   # draw a triangle
   glBegin(GL_POLYGON);						# start drawing a polygon
   glVertex( 0.0, 1.0, 0.0);					# Top
   glVertex( 1.0,-1.0, 0.0);					# Bottom Right
   glVertex(-1.0,-1.0, 0.0);					# Bottom Left	
   glEnd();							# we're done with the polygon
   
   glTranslate(3.0,0.0,0.0);					# Move Right 3 Units
   
   # draw a square (quadrilateral)
   glBegin(GL_QUADS);						# start drawing a polygon (4 sided)
   glVertex(-1.0, 1.0, 0.0);					# Top Left
   glVertex( 1.0, 1.0, 0.0);					# Top Right
   glVertex( 1.0,-1.0, 0.0);					# Bottom Right
   glVertex(-1.0,-1.0, 0.0);					# Bottom Left	
   glEnd();							# done with the polygon
   
   
  }





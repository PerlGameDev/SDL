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
use Data::Dumper;
use Benchmark;

use SDL;
use SDL::App;
use SDL::OpenGL;
use SDL::Event;
use SDL::Surface;
use SDL::Cursor;
use SDL::OpenGL;

my $arg_screen_width =640;
my $arg_screen_height=512;
my $arg_fullscreen=0;

GetOptions(
	   "width:i"        => \$arg_screen_width,
	   "height:i"       => \$arg_screen_height,
	   "fullscreen!"    => \$arg_fullscreen,

	  ) or die $!;

############################################################

my  $light = 0;

my $xrot=0;   # x rotation 
my $yrot=0;   # y rotation 
my $xspeed=0; # x rotation speed
my $yspeed=0; # y rotation speed

my $z=-5.0; # depth into the screen.

my $filter = 1;	# Which Filter To Use (nearest/linear/mipmapped) */
my $blend  = 1;


print STDERR "Use b to toggle blend, page up/down to zoom, and arrow keys to rotate\n";

main();
exit;


sub main
  {  
   my $done=0;
   my $vidmode_flags= SDL_OPENGL;

   $vidmode_flags|= SDL_FULLSCREEN if $arg_fullscreen;
   
   my $app = new SDL::App ( -title => "Jeff Molofee's GL Code Tutorial ... NeHe '99", 
			    -icon => "icon.png",
			    -flags => $vidmode_flags,			
			    -width => $arg_screen_width,
			    -height =>$arg_screen_height,
			    -opengl => 1,
			  );
   
   SDL::ShowCursor(0);
   
   my $event = new SDL::Event;
   $event->set(SDL_SYSWMEVENT,SDL_IGNORE);
   
   InitGL($arg_screen_width, $arg_screen_height);

   glEnable(GL_BLEND);		    # Turn Blending On
   glEnable(GL_LIGHTING);
   glDisable(GL_DEPTH_TEST);         # Turn Depth Testing Off

   while ( not $done ) 
     {
      
      DrawGLScene();

      $app->sync();
      
      $event->pump;
      $event->poll;
      
      $done = 1 if ( $event->type == SDL_QUIT ) ;
      
      if ( $event->type == SDL_KEYDOWN ) 
	{
	 my $key= $event->key_sym;

	 $done = 1 if ( $key == SDLK_ESCAPE ) ;
	 
	 if ($key==SDLK_f)
	   {
	    printf("Filter was: %d\n", $filter);
	    $filter = 1+(($filter) % 3) ;
	    printf("Filter is now: %d\n", $filter);	 
	    $app->delay(100);
	   } 
	 if ($key == SDLK_b)
	   {
	    printf("Blend was: %d\n", $blend);
	    $blend = $blend ? 0 : 1;              
	    printf("Blend is now: %d\n", $blend);
		$app->delay(100);
	    if ($blend) 
	      {
	       glEnable(GL_BLEND);		    # Turn Blending On
	       glEnable(GL_LIGHTING);
	       glDisable(GL_DEPTH_TEST);         # Turn Depth Testing Off
	      } 
	    else 
	      {
	       glDisable(GL_BLEND);              # Turn Blending Off
	       glDisable(GL_LIGHTING);
	       glEnable(GL_DEPTH_TEST);          # Turn Depth Testing On
	      }
	   }
	 #bit lax:
	 $z-=0.02      if ( $key == SDLK_PAGEUP );
	 $z+=0.02      if ( $key == SDLK_PAGEDOWN );
	 $xspeed+=0.02 if ( $key == SDLK_UP );
	 $xspeed-=0.02 if ( $key == SDLK_DOWN );	 
	 $yspeed-=0.01 if ( $key == SDLK_LEFT );
	 $yspeed+=0.01 if ( $key == SDLK_RIGHT );
	 
	}
     }
  }






#########################################################################
#Pretty much in original form, but 'Perlised' 




sub InitGL
  {
   my ($Width, $Height) = @_;

   glViewport(0, 0, $Width, $Height);

   LoadGLTextures();				# Load The Texture(s) 

   glEnable(GL_TEXTURE_2D);			# Enable Texture Mapping

   
   glClearColor(0.0, 0.0, 0.0, 0.0);				# This Will Clear The Background Color To Black
   glClearDepth(1.0);						# Enables Clearing Of The Depth Buffer
   glDepthFunc(GL_LESS);					# The Type Of Depth Test To Do
   glEnable(GL_DEPTH_TEST);					# Enables Depth Testing
   glShadeModel(GL_SMOOTH);					# Enables Smooth Color Shading
   
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();						# Reset The Projection Matrix
   
   gluPerspective(45.0, $Width/$Height, 0.1, 100.0);		# Calculate The Aspect Ratio Of The Window
   
   glMatrixMode(GL_MODELVIEW);

   
   my $LightAmbient  = [ 0.5, 0.5, 0.5, 1.0 ];                   # white ambient light at half intensity (rgba) */

   my $LightDiffuse  = [ 1.0, 1.0, 1.0, 1.0 ];                    # super bright, full intensity diffuse light. */

   my $LightPosition = [ 0.0 , 0.0, 2.0, 1.0 ];                 # position of light (x, y, z, (position of light)) */



   #setup light number 1
   glLight(GL_LIGHT1, GL_AMBIENT, @$LightAmbient);  # add lighting. (ambient)
   glLight(GL_LIGHT1, GL_DIFFUSE, @$LightDiffuse);  # add lighting. (diffuse).
   glLight(GL_LIGHT1, GL_POSITION,@$LightPosition); # set light position.
   glEnable(GL_LIGHT1);                             # turn light 1 on.  
   #/* setup blending */
   glBlendFunc(GL_SRC_ALPHA,GL_ONE);			# Set The Blending Function For Translucency
   glColor(1.0, 1.0, 1.0, 0.5);    


  }



# The main drawing function.
sub DrawGLScene
  {
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);		# Clear The Screen And The Depth Buffer
   glLoadIdentity();						# Reset The View
   
   glTranslate(0.0,0.0,$z);                  # move z units out from the screen.
    
   glRotate($xrot,1.0,0.0,0.0);		# Rotate On The X Axis
   glRotate($yrot,0.0,1.0,0.0);		# Rotate On The Y Axis
   
   glBindTexture(GL_TEXTURE_2D, $filter);			# choose the texture to use.
   
   glBegin(GL_QUADS);						# begin drawing a cube
   
   # Front Face (note that the texture's corners have to match the quad's corners)
   glNormal( 0.0, 0.0, 1.0);					# front face points out of the screen on z.
   glTexCoord(0.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0,  1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0,  1.0);	# Top Left Of The Texture and Quad
   
   # Back Face
   glNormal( 0.0, 0.0,-1.0);					# back face points into the screen on z.
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0, -1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0, -1.0);	# Bottom Left Of The Texture and Quad
   
   # Top Face
   glNormal( 0.0, 1.0, 0.0);					# top face points up on y.
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex(-1.0,  1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex( 1.0,  1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   
   # Bottom Face       
   glNormal( 0.0, -1.0, 0.0);					# bottom face points down on y. 
   glTexCoord(1.0, 1.0); glVertex(-1.0, -1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0, -1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   
   # Right face
   glNormal( 1.0, 0.0, 0.0);					# right face points right on x.
   glTexCoord(1.0, 0.0); glVertex( 1.0, -1.0, -1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0,  1.0,  1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   
   # Left Face
   glNormal(-1.0, 0.0, 0.0);					# left face points left on x.
   glTexCoord(0.0, 0.0); glVertex(-1.0, -1.0, -1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex(-1.0,  1.0,  1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   
   glEnd();							# done with the polygon.
   
   $xrot+=$xspeed;						# X Axis Rotation	
   $yrot+=$yspeed;						# Y Axis Rotation
   
   
   
  }




sub LoadGLTextures
  {
    # Load Texture

   
   my ($pixels, $width, $height, $size)=ImageLoad("Data/glass.bmp");
   
   # Create Texture	
   
   glGenTextures(3);
   
   # texture 1 (poor quality scaling)
   glBindTexture(GL_TEXTURE_2D, 1);			# 2d texture (x and y size)
   
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST); # cheap scaling when image bigger than texture
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST); # cheap scaling when image smalled than texture
   
   # 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image, 
   # border 0 (normal), rgb color data, unsigned byte data, and finally the data itself.
   #glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);
   
   glTexImage2D(GL_TEXTURE_2D, 
		  0,						#level (0 normal, heighr is form mip-mapping)
		  3,						#internal format (3=GL_RGB)
		  $width,$height,
		  0,						# border 
		  GL_RGB,					#format RGB color data
		  GL_UNSIGNED_BYTE,				#unsigned bye data
		  $pixels);				#ptr to texture data
   


   # texture 2 (linear scaling)
   glBindTexture(GL_TEXTURE_2D, 2);			# 2d texture (x and y size)
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); # scale linearly when image bigger than texture
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); # scale linearly when image smalled than texture
   #glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);
   
   glTexImage2D(GL_TEXTURE_2D, 
		  0,						#level (0 normal, heighr is form mip-mapping)
		  3,						#internal format (3=GL_RGB)
		  $width,$height,
		  0,						# border 
		  GL_RGB,					#format RGB color data
		  GL_UNSIGNED_BYTE,				#unsigned bye data
		  $pixels);				#ptr to texture data



   
   # texture 3 (mipmapped scaling)
   glBindTexture(GL_TEXTURE_2D, 3);			# 2d texture (x and y size)
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); # scale linearly when image bigger than texture
   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST); # scale linearly + mipmap when image smalled than texture
   #glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);
   
   glTexImage2D(GL_TEXTURE_2D, 
		  0,						#level (0 normal, heighr is form mip-mapping)
		  3,						#internal format (3=GL_RGB)
		  $width,$height,
		  0,						# border 
		  GL_RGB,					#format RGB color data
		  GL_UNSIGNED_BYTE,				#unsigned bye data
		  $pixels);				#ptr to texture data
   
   # 2d texture, 3 colors, width, height, RGB in that order, byte data, and the data.
   gluBuild2DMipmaps(GL_TEXTURE_2D, 3, $width, $height, GL_RGB, GL_UNSIGNED_BYTE, $pixels); 
   
   my $glerr=glGetError();
   die "Problem setting up 2d Texture (dimensions not a power of 2?)):".gluErrorString($glerr)."\n" if $glerr;
   
  }











#somthing needs to keep the ref count alive for objects which represents data in C space (they have no ref count):
my @ref=();
 
sub ImageLoad
  {
   my $filename=shift;

   my $surface = new SDL::Surface( -name  => $filename); #makes use of SDL: BMP loader.
   
   
   my $width=$surface->width();
   my $height=$surface->height();
   my $bytespp=  $surface->bytes_per_pixel();
   my $size=   $width*$height*$bytespp;

   my $surface_pixels=$surface->pixels();
   my $surface_size=$width*$height*$surface->bytes_per_pixel();
   my $raw_pixels = reverse $surface_pixels;   
   

   
   #do a conversion (the pixel data is accessable as a simple string)

   my $pixels=$raw_pixels;
   my $pre_conv= $pixels;
   my $new_pixels="";
   for (my $y=0; $y< $height; $y++)
     {
      my $y_pos=$y*$width*$bytespp;              #calculate offset into the image (a string)
      my $row=substr ($pre_conv, $y_pos, $width*$bytespp); #extract 1 pixel row
      $row =~ s/\G(.)(.)(.)/$3$2$1/gms;                    #turn the BMP BGR order into OpenGL RGB order;  
      $new_pixels.= reverse $row;       
     }
   
   $raw_pixels = $new_pixels;                #put transformed data into C array.
   push @ref, $raw_pixels, $surface;

   #we could have created another SDL surface frm the '$raw_pixel's... oh well.
   return ($raw_pixels, $width, $height, $size);
  }

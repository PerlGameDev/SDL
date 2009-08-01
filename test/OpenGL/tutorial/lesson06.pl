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

my $arg_screen_width =640;
my $arg_screen_height=512;
my $arg_fullscreen=0;
my $delay = 3;

GetOptions(
	   "width:i"        => \$arg_screen_width,
	   "height:i"       => \$arg_screen_height,
	   "fullscreen!"    => \$arg_fullscreen,
	   "delay:i"	=> \$delay,

	  ) or die $!;

############################################################

my ($xrot, $yrot, $zrot) = (0,0,0);

main();
exit;


sub main
  {  
   my $done=0;
   
   my $app = new SDL::App ( -title => "Jeff Molofee's GL Code Tutorial ... NeHe '99", 
			    -icon => "Data/perl.png",
			    -width => $arg_screen_width,
			    -height =>$arg_screen_height,
			    -opengl => 1,
			  );
   $app->fullscreen() if $arg_fullscreen;
   
   SDL::ShowCursor(0);   

   my $event = new SDL::Event;
   $event->set(SDL_SYSWMEVENT,SDL_IGNORE);
   
   InitGL($arg_screen_width, $arg_screen_height);


   while ( not $done ) {

    DrawGLScene();

    $app->sync();
   
    for (1 .. 10) {
    	$event->pump;
    	$event->poll;
    	$app->delay($delay);
    }
    
    
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
   my ($Width, $Height) = @_;

   glViewport(0, 0, $Width, $Height);

   LoadGLTextures();				# Load The Texture(s) 

   glEnable(GL_TEXTURE_2D());			# Enable Texture Mapping

   glClearColor(0.0, 0.0, 1.0, 0.0);				# This Will Clear The Background Color To Black
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
   
 
   glTranslate(0.0,0.0,-5.0);                                  # move 5 units into the screen.
   
   glRotate($xrot,1.0,0.0,0.0);				# Rotate On The X Axis
   glRotate($yrot,0.0,1.0,0.0);				# Rotate On The Y Axis
   glRotate($zrot,0.0,0.0,1.0);				# Rotate On The Z Axis
   
   glBindTexture(GL_TEXTURE_2D, 1);   # choose the texture to use.
   
   glBegin(GL_QUADS);						# begin drawing a cube
   
   # Front Face (note that the texture's corners have to match the quad's corners)
   glTexCoord(0.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0,  1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0,  1.0);	# Top Left Of The Texture and Quad
   
   # Back Face
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0, -1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0, -1.0);	# Bottom Left Of The Texture and Quad
   
   # Top Face
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex(-1.0,  1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex( 1.0,  1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   
   # Bottom Face       
   glTexCoord(1.0, 1.0); glVertex(-1.0, -1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0, -1.0, -1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   
   # Right face
   glTexCoord(1.0, 0.0); glVertex( 1.0, -1.0, -1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex( 1.0,  1.0, -1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex( 1.0,  1.0,  1.0);	# Top Left Of The Texture and Quad
   glTexCoord(0.0, 0.0); glVertex( 1.0, -1.0,  1.0);	# Bottom Left Of The Texture and Quad
   
   # Left Face
   glTexCoord(0.0, 0.0); glVertex(-1.0, -1.0, -1.0);	# Bottom Left Of The Texture and Quad
   glTexCoord(1.0, 0.0); glVertex(-1.0, -1.0,  1.0);	# Bottom Right Of The Texture and Quad
   glTexCoord(1.0, 1.0); glVertex(-1.0,  1.0,  1.0);	# Top Right Of The Texture and Quad
   glTexCoord(0.0, 1.0); glVertex(-1.0,  1.0, -1.0);	# Top Left Of The Texture and Quad
   
   glEnd();							# done with the polygon.
   
   $xrot+=15.0;							# X Axis Rotation	
   $yrot+=15.0;							# Y Axis Rotation
   $zrot+=15.0;							# Z Axis Rotation

   
  }

#my $image1,$a;  #this can cause a segfault in LoadGLTextures/glTexImage2D   !!!


sub LoadGLTextures
  {
    # Load Texture

   #uncomment this for a different method of loading:
   #my $img_data  = read_gfx_file(FILENAME=>"../../ScrollerDemos/backdrop2.h");
   #my $pixel_ptr = $img_data->{PIXEL_PTR};
   #my $pic_info  = $img_data->{INFO};
   #my $width     = $pic_info->{WIDTH};
   #my $height    = $pic_info->{HEIGHT};

    
   #if you uncomment the bit above, comment this out:
   #-snip-
   my $surface=create_SDL_surface_from_file("Data/crate.png");
   my $width=$surface->width();
   my $height=$surface->height();
   my $pitch = $surface->pitch();
   my $bytespp=  $surface->bytes_per_pixel();
   my $size=$pitch*$height;
   my $pixels = $surface->pixels();

   # Create Texture	
   my $textures = glGenTextures(1);                #name texture
	die "Could not genereate textures" unless $$textures[0];

   glBindTexture(GL_TEXTURE_2D, $$textures[0]);   # 2d texture 
   
   
   glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); # scale linearly when image bigger than texture
   glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); # scale linearly when image smalled than texture
  
   glTexImage2D(GL_TEXTURE_2D(), 
		   0,                      #level (0 normal, heighr is form mip-mapping)
		   GL_RGB(),                      #internal format (3=GL_RGB)
		   $width,$height,
		   0,                      # border 
		   GL_RGB(),                 #format RGB color data
		  GL_UNSIGNED_BYTE(),       #unsigned bye data
		  $pixels);            #ptr to texture data

    die "Problem setting up 2d Texture (dimensions not a power of 2?)):".glErrorString(glGetError())."\n" if glGetError();

  }

sub create_SDL_surface_from_file
  {
   my $filename=shift;
   
   my $surface = new SDL::Surface( -name  => $filename);
   
   return $surface;
			       
  }





###################
#alternat loading support:

#keep ref counts up:
my @sprite_c_heap =();
my @sprite_area =();

sub read_gfx_file
  {
   my %args=(
	     TYPE       => "GIMP_HEADER",
	     FILENAME  => undef,
	     @_,
	    );
   
   my $struct   = read_gimp_header_image($args{FILENAME}); 
   my $size     = length $struct->{DATA};
   my $c_array  = new OpenGL::Array  $size  , GL_UNSIGNED_BYTE;

   # c_array is the main reason to do the following ref count trickster:
   # (otherwise the OpenGL:Array goes out of scope and the memory (image) is ZEROed out (and invalidated) by the DESTROY method
   push @sprite_c_heap,  $c_array;             
   push @sprite_area,    $struct;

   $c_array->assign_data(0, $struct->{DATA} );   #take a copy of the data
   
   return {
	   PIXEL_PTR   => $c_array->ptr(), #could return $c_array instead to kepe ref count alive
	   INFO        => $struct,
	  };

   #that all needs modularising.....

  }


#nasty fixed to 3 byte RGB 
sub read_gimp_header_image
  {
   my $file=shift;
   my $cached_file="$file.cached-bin";

   my ($width, $height,$pixel_format, $data)=(0,0,"RGB","");

   #due to that fact that this aint the fastest code ever, we keep a cache.
   if (-e $cached_file and (-C $file >= -C $cached_file))
     {

      print "Reading cached binary bitmap data :  $cached_file\n";
      open (FH, "<$file.cached-bin") or die "Open: $!";
      my $line="";
      $width=<FH>;
      $height=<FH>;
      $pixel_format=<FH>;
      chomp $width;
      chomp $height;
      chomp $pixel_format;  #but who cares? not here anyway!!!

      #slurp in the rest of the file (its pixel data)
      {
       local $/;
       undef $/;
       
       my @lines= <FH>;
       $data=join '', @lines;
      }
      
      close (FH);
     }
   else                 # there is no cached file, or the cached file is out of date.
     {
      
      open (FH, "<$file") or die "Open: $!";

      my @data=();
      my @pixel=();
      while (defined (my $line=<FH>))
	{
	 $width =$1 if ($line =~ /width\s*=\s*(\d+)/);
	 $height=$1 if ($line =~ /height\s*=\s*(\d+)/);
	 if ($line =~ /^\s+\"(.+)\"$/g)
	   {
	    my $c=$1;
	    $c =~ s/\\(.)/$1/g;					#remove meta guard
	    $c =~ 
	      s/
		\G
		  (.)(.)(.)(.)
		    /
		      @data=(ord($1),ord($2),ord($3),ord($4));
	    
	    chr    (  (  (  ( $data[0] - 33) <<  2)       | (  ($data[1] - 33) >> 4) ) ). 
	      chr (  (  (  (  ( $data[1] - 33) & 0xF) << 4) | (  ($data[2] - 33) >> 2) ) ).
		chr (  (  (  (  ( $data[2] - 33) & 0x3) << 6) | (  ($data[3] - 33)     ) ) ); 
	    /gex;      
	    
	    $data.=$c ;
	   }
	}
      
      
      close(FH);
      
      print "Writing cached binary bitmap data for:  $file as $cached_file\n";
      
      #create a binary cached copy
      open (FH, ">$cached_file") or die "Open: $!";
      binmode FH;  #we might have to put up with weak OSes.
      print FH  "$width\n$height\n$pixel_format\n$data";

      close(FH);
     }
   



   return {
	   WIDTH  => $width,
	   HEIGHT => $height,
	   FORMAT => $pixel_format,
	   DATA   => $data
	  };
  }



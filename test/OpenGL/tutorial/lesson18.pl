#!/usr/bin/perl 
# This code was created by Jeff Molofee '99
# (ported to SDL by Sam Lantinga '2000)
# (ported to Linux/SDL by Ti Leggett '01)

# Lesson18 adapted by JusTiCe8 @2007 from others lesson and
# 	ported to new Perl SDL, comments stripped (see Nehe lessons)

# If you've found this code useful, please let me know.

# Visit Jeff at http://nehe.gamedev.net/
 
# or for port-specific comments, questions, bugreports etc. 
# email to leggett@eecs.tulane.edu (C/SDL)
# or justice8@wanadoo.fr (SDL-Perl)

use strict;
use Getopt::Long;

use SDL::Constants;
use SDL::App;
use SDL::OpenGL::Constants;
use SDL::OpenGL;
use SDL::Event;
use SDL::Cursor;     

use constant NUM_TEXTURES => 3;

my $arg_screen_width = 640;
my $arg_screen_height = 480;
my $arg_fullscreen = 0;
my $delay = 5;

my $light = 0;

my ($part1, $part2);
my ($p1, $p2) = (0, 1);

my ($xrot, $yrot, $xspeed, $yspeed);
my $z = -5.0;

my $LightAmbient = [ 0.5, 0.5, 0.5, 1.0 ];
my $LightDiffuse = [ 1.0, 1.0, 1.0, 1.0 ];
my $LightPosition = [ 0.0, 0.0, 2.0, 1.0 ];

my $quadratic;
my $object = 5;
my $filter = 1;

# this flag is used to limit key strokes event
my $pressed = 0;

GetOptions
	(
		"width:i"	=> \$arg_screen_width,
		"height:i"	=> \$arg_screen_height,
		"fullscreen!"	=> \$arg_fullscreen,
		"delay:i"	=> \$delay,
	  )
	  or die $!;

main();
exit;

sub main
{ 
	my $done = 0;
	my $fps = 0.0;
	my $frames_drawn = 0;
   
	my $app = new SDL::App 
				(
					-title	=> "Jeff Molofee's lesson18: Quadratic",
					-icon	=> "icon.png",
					-width	=> $arg_screen_width,
					-height	=> $arg_screen_height,
					-opengl	=> 1,
				);

	$app->fullscreen if ($arg_fullscreen);
   
	SDL::ShowCursor (0);
   
	my $event = new SDL::Event;
	$event->set (SDL_SYSWMEVENT (), SDL_IGNORE ());

	InitGL ($arg_screen_width, $arg_screen_height);

	my $prev_ticks = $app->ticks ();
	my $fps_counter = 0.0;

	while ( !$done )
	{
		DrawGLScene ();

		$app->sync ();
		$app->delay ($delay) if ($delay > 0);
		$frames_drawn++;

		my $ticks_now = $app->ticks ();
		$fps_counter += $ticks_now - $prev_ticks;
		$prev_ticks = $ticks_now;

		if( $fps_counter >= 5000.0)
		{
			$fps = $frames_drawn / ($fps_counter / 1000.0);
			printf("%d frames in %.2f seconds = %.3f FPS\n", $frames_drawn, $fps_counter / 1000.0, $fps);
			$frames_drawn = 0;
			$fps_counter = 0.0;
		}

		$event->pump;
		$event->poll;
    
		$done = 1 if ($event->type == &SDL_QUIT );
		
		if ($event->type == &SDL_KEYDOWN )
		{
			$done = 1 if ($event->key_sym == &SDLK_ESCAPE );

			if ($event->key_sym == &SDLK_f and !$pressed)
			{
				$filter = 1 + $filter % 3;
				#print "Filter = $filter\n";
				$pressed = 1;
			}
			elsif ($event->key_sym == &SDLK_l and !$pressed)
			{
				$light = !$light;
				if (!$light)
				{
					glDisable ( &GL_LIGHTING );
				} else {
					glEnable ( &GL_LIGHTING );
				}
				$pressed = 1;
			}
			elsif ($event->key_sym == &SDLK_SPACE and !$pressed)
			{
				$object = ++$object % 6;
				$pressed = 1;
			}
			elsif ($event->key_sym == &SDLK_PAGEUP)
			{
				$z -= 0.02;
			}
			elsif ($event->key_sym == &SDLK_PAGEDOWN)
			{
				$z += 0.02;
			}
			elsif ($event->key_sym == &SDLK_UP)
			{
				$xspeed -= 0.01;
			}
			elsif ($event->key_sym == &SDLK_DOWN)
			{
				$xspeed += 0.01;
			}
			elsif ($event->key_sym == &SDLK_RIGHT)
			{
				$yspeed += 0.01;
			}
			elsif ($event->key_sym == &SDLK_LEFT)
			{
				$yspeed -= 0.01;
			}
		}
		elsif ($event->type == &SDL_KEYUP)
		{
			$pressed = 0;
		}
	}
}


sub InitGL
{
	my ($Width, $Height) = @_;
	($xrot, $yrot) = (0.0, 0.0);

	glViewport (0, 0, $Width, $Height);

	LoadGLTexture ();
	glEnable (&GL_TEXTURE_2D);
	glShadeModel (&GL_SMOOTH);

	glClearColor (0.0, 0.0, 0.0, 0.0);
	glClearDepth (1.0);

	glEnable (&GL_DEPTH_TEST);
	glDepthFunc (&GL_LESS);		# GL_EQUAL as source tutorial don't work (?)
	glHint ( &GL_PERSPECTIVE_CORRECTION_HINT, &GL_NICEST );
   
    glLight ( &GL_LIGHT1, &GL_AMBIENT, @$LightAmbient );
    glLight ( &GL_LIGHT1, &GL_DIFFUSE, @{$LightDiffuse} );
    glLight ( &GL_LIGHT1, &GL_POSITION, @{$LightPosition} );

    glEnable ( &GL_LIGHT1 );

	$quadratic = gluNewQuadric ();
	#gluQuadricNormals ( $quadratic, &GLU_SMOOTH );
	gluQuadricTexture ( $quadratic, &GL_TRUE );

	glMatrixMode (&GL_PROJECTION);
	glLoadIdentity ();
   
	gluPerspective (45.0, $Width/$Height, 0.1, 100.0);
   
	glMatrixMode (&GL_MODELVIEW);
}


sub drawGLCube
{
	glBegin (&GL_QUADS);
  
	glNormal ( 0.0, 0.0, 1.0);
	glTexCoord (1.0, 0.0); glVertex (-1.0, -1.0,  1.0);
	glTexCoord (0.0, 0.0); glVertex ( 1.0, -1.0,  1.0);
	glTexCoord (0.0, 1.0); glVertex ( 1.0,  1.0,  1.0);
	glTexCoord (1.0, 1.0); glVertex (-1.0,  1.0,  1.0);
   
	glNormal ( 0.0, 0.0,-1.0);
	glTexCoord (0.0, 0.0); glVertex (-1.0, -1.0, -1.0);
	glTexCoord (0.0, 1.0); glVertex (-1.0,  1.0, -1.0);
	glTexCoord (1.0, 1.0); glVertex ( 1.0,  1.0, -1.0);
	glTexCoord (1.0, 0.0); glVertex ( 1.0, -1.0, -1.0);
   
	glNormal ( 0.0, 1.0, 0.0);
	glTexCoord( 1.0, 1.0); glVertex (-1.0,  1.0, -1.0);
	glTexCoord (1.0, 0.0); glVertex (-1.0,  1.0,  1.0);
	glTexCoord (0.0, 0.0); glVertex ( 1.0,  1.0,  1.0);
	glTexCoord (0.0, 1.0); glVertex ( 1.0,  1.0, -1.0);
   
	glNormal ( 0.0, -1.0, 0.0);
	glTexCoord (0.0, 1.0); glVertex (-1.0, -1.0, -1.0);
	glTexCoord (1.0, 1.0); glVertex ( 1.0, -1.0, -1.0);
	glTexCoord (1.0, 0.0); glVertex ( 1.0, -1.0,  1.0);
	glTexCoord (0.0, 0.0); glVertex (-1.0, -1.0,  1.0);
    
	glNormal ( 1.0, 0.0, 0.0);
	glTexCoord (0.0, 0.0); glVertex ( 1.0, -1.0, -1.0);
	glTexCoord (0.0, 1.0); glVertex ( 1.0,  1.0, -1.0);
	glTexCoord (1.0, 1.0); glVertex ( 1.0,  1.0,  1.0);
	glTexCoord (1.0, 0.0); glVertex ( 1.0, -1.0,  1.0);
   
	glNormal (-1.0, 0.0, 0.0);
	glTexCoord (1.0, 0.0); glVertex (-1.0, -1.0, -1.0);
	glTexCoord (0.0, 0.0); glVertex (-1.0, -1.0,  1.0);
	glTexCoord (0.0, 1.0); glVertex (-1.0,  1.0,  1.0);
	glTexCoord (1.0, 1.0); glVertex (-1.0,  1.0, -1.0);

	glEnd();
}


sub DrawGLScene
{
	glClear(&GL_COLOR_BUFFER_BIT | &GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
   
	glTranslate ( 0.0, 0.0, $z);

	glRotate ($xrot, 1.0, 0.0, 0.0);
	glRotate ($yrot, 0.0, 1.0, 0.0);

	glBindTexture(&GL_TEXTURE_2D, $filter);

	if ($object == 0)
	{
		drawGLCube ();
	}
	elsif ($object == 1)
	{
		glTranslate ( 0.0, 0.0, -1.5 );
		gluCylinder ( $quadratic, 1.0, 1.0, 3.0, 32, 32 );
	}
	elsif ($object == 2)
	{
		gluDisk ( $quadratic, 0.5, 1.5, 32, 32 );
	}
	elsif ($object == 3)
	{
		gluSphere ( $quadratic, 1.3, 32, 32 );
	}
	elsif ($object == 4)
	{
		glTranslate ( 0.0, 0.0, -1.5 );
		gluCylinder ( $quadratic, 1.0, 0.0, 3.0, 32, 32 );
	}
	elsif ($object == 5)
	{
		$part1 += $p1;
		$part2 += $p2;
		if ( $part1 > 359 )
		{
			$p1 = 0;
			$part1 = 0;
			$p2 = 1;
			$part2 = 0;
		}
		if ( $part2 > 359 )
		{
			$p1 = 1;
			$p2 = 0;
		}

		gluPartialDisk ( $quadratic, 0.5, 1.5, 32, 32, $part1, $part2 - $part1 );
	}

	$xrot += $xspeed;
	$yrot += $yspeed;
}


sub LoadGLTexture
{
	my ($pixels, $width, $height, $size) = ImageLoad ('data/wall.bmp');
	#print "LoadGLTexture: w:$width h:$height s:$size\n";
   
	my $textures = glGenTextures (NUM_TEXTURES);
	unless ($$textures[0])
	{
		print "Could not generate textures\n";
		return 0;
	}

	glBindTexture (&GL_TEXTURE_2D, 1); #$$textures[0]);

	glTexImage2D 
				(
					&GL_TEXTURE_2D,
					0,
					3,
					$width, $height,
					0,
					&GL_BGR,
					&GL_UNSIGNED_BYTE,
					$pixels
				);
   
	glTexParameter(&GL_TEXTURE_2D, &GL_TEXTURE_MAG_FILTER, &GL_NEAREST);
	glTexParameter(&GL_TEXTURE_2D, &GL_TEXTURE_MIN_FILTER, &GL_NEAREST);
   

	glBindTexture (&GL_TEXTURE_2D, 2);

	glTexImage2D 
				(
					&GL_TEXTURE_2D,
					0,
					3,
					$width, $height,
					0,
					&GL_BGR,
					&GL_UNSIGNED_BYTE,
					$pixels
				);
  
	glTexParameter (&GL_TEXTURE_2D, &GL_TEXTURE_MIN_FILTER, &GL_LINEAR);
	glTexParameter (&GL_TEXTURE_2D, &GL_TEXTURE_MAG_FILTER, &GL_LINEAR); 


	glBindTexture (&GL_TEXTURE_2D, 3);

	glTexParameter (&GL_TEXTURE_2D, &GL_TEXTURE_MIN_FILTER, &GL_LINEAR_MIPMAP_NEAREST);
	glTexParameter (&GL_TEXTURE_2D, &GL_TEXTURE_MAG_FILTER, &GL_LINEAR); 

	gluBuild2DMipmaps 
				(
					&GL_TEXTURE_2D,
					3,
					$width, $height,
					&GL_BGR,
					&GL_UNSIGNED_BYTE,
					$pixels
				);
  
	my $glerr = glGetError ();
	if ($glerr)
	{
		print "Problem setting up 2d Texture (dimensions not a power of 2?)): ".gluErrorString ($glerr)."\n";
		return 0;
	}
}

 
sub ImageLoad
{
	my $filename = shift;
	return unless (defined $filename and -e $filename);

	#somthing needs to keep the ref count alive for objects which represents data in C space (they have no ref count):
	my @ref = ();

	#makes use of SDL: BMP loader.
	my $surface = new SDL::Surface (-name  => $filename);
   
	my $width = $surface->width ();
	my $height = $surface->height ();
	my $bytespp = $surface->bytes_per_pixel ();
	my $size = $width * $height * $bytespp;

	return ($surface->pixels (), $width, $height, $size);


	my $surface_pixels = $surface->pixels ();
	my $surface_size = $width * $height * $surface->bytes_per_pixel ();
	my $raw_pixels = reverse $surface_pixels;
   
	#do a conversion (the pixel data is accessable as a simple string)
	my $pixels = $raw_pixels;
	my $pre_conv = $pixels;
	my $new_pixels = '';

	for (my $y = 0; $y< $height; $y++)
	{
		# calculate offset into the image (a string)
		my $y_pos = $y * $width * $bytespp;

		# extract 1 pixel row
		my $row = substr ($pre_conv, $y_pos, $width*$bytespp);

		# turn the BMP BGR order into OpenGL RGB order;
		$row =~ s/\G(.)(.)(.)/$3$2$1/gms;
		$new_pixels .= reverse $row;       
	}
   
	$raw_pixels = $new_pixels;
	push @ref, $raw_pixels, $surface;

	# we could have created another SDL surface frm the '$raw_pixel's... oh well.
	return ($raw_pixels, $width, $height, $size);
}


END
{
	gluDeleteQuadric ($quadratic);
	$quadratic = undef;
=item rem
	use Devel::Peek;
	print "Q=$quadratic\n";
	mstat;
	Dump ($quadratic, 5);
	gluDeleteQuadric ($quadratic);
	Dump ($quadratic, 5);
	$quadratic = undef;
	print "Q=$quadratic\n";
	Dump ($quadratic, 5);
=cut
}

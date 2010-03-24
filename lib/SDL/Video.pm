package SDL::Video;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Video;

use base 'Exporter';

our @EXPORT = qw(
	SDL_SWSURFACE
	SDL_HWSURFACE
	SDL_ASYNCBLIT
	SDL_ANYFORMAT
	SDL_HWPALETTE
	SDL_DOUBLEBUF
	SDL_FULLSCREEN
	SDL_OPENGL
	SDL_OPENGLBLIT
	SDL_RESIZABLE
	SDL_NOFRAME
	SDL_HWACCEL
	SDL_SRCCOLORKEY
	SDL_RLEACCELOK
	SDL_RLEACCEL
	SDL_SRCALPHA
	SDL_PREALLOC
	SDL_YV12_OVERLAY
	SDL_IYUV_OVERLAY
	SDL_YUY2_OVERLAY
	SDL_UYVY_OVERLAY
	SDL_YVYU_OVERLAY
	SDL_LOGPAL
	SDL_PHYSPAL
	SDL_GRAB_QUERY
	SDL_GRAB_OFF
	SDL_GRAB_ON
	SDL_GRAB_FULLSCREEN
	SDL_GL_RED_SIZE
	SDL_GL_GREEN_SIZE
	SDL_GL_BLUE_SIZE
	SDL_GL_ALPHA_SIZE
	SDL_GL_BUFFER_SIZE
	SDL_GL_DOUBLEBUFFER
	SDL_GL_DEPTH_SIZE
	SDL_GL_STENCIL_SIZE
	SDL_GL_ACCUM_RED_SIZE
	SDL_GL_ACCUM_GREEN_SIZE
	SDL_GL_ACCUM_BLUE_SIZE
	SDL_GL_ACCUM_ALPHA_SIZE
	SDL_GL_STEREO
	SDL_GL_MULTISAMPLEBUFFERS
	SDL_GL_MULTISAMPLESAMPLES
	SDL_GL_ACCELERATED_VISUAL
	SDL_GL_SWAP_CONTROL
);

our %EXPORT_TAGS = 
(
	surface => [qw(
		SDL_SWSURFACE
		SDL_HWSURFACE
		SDL_ASYNCBLIT
	)],
	video => [qw(
		SDL_SWSURFACE
		SDL_HWSURFACE
		SDL_ASYNCBLIT
		SDL_ANYFORMAT
		SDL_HWPALETTE
		SDL_DOUBLEBUF
		SDL_FULLSCREEN
		SDL_OPENGL
		SDL_OPENGLBLIT
		SDL_RESIZABLE
		SDL_NOFRAME
		SDL_HWACCEL
		SDL_SRCCOLORKEY
		SDL_RLEACCELOK
		SDL_RLEACCEL
		SDL_SRCALPHA
		SDL_PREALLOC
	)],
	overlay => [qw(
		SDL_YV12_OVERLAY
		SDL_IYUV_OVERLAY
		SDL_YUY2_OVERLAY
		SDL_UYVY_OVERLAY
		SDL_YVYU_OVERLAY
	)],
	palette => [qw(
		SDL_LOGPAL
		SDL_PHYSPAL
	)],
	grab => [qw(
		SDL_GRAB_QUERY
		SDL_GRAB_OFF
		SDL_GRAB_ON
		SDL_GRAB_FULLSCREEN
	)],
	gl => [qw(
		SDL_GL_RED_SIZE
		SDL_GL_GREEN_SIZE
		SDL_GL_BLUE_SIZE
		SDL_GL_ALPHA_SIZE
		SDL_GL_BUFFER_SIZE
		SDL_GL_DOUBLEBUFFER
		SDL_GL_DEPTH_SIZE
		SDL_GL_STENCIL_SIZE
		SDL_GL_ACCUM_RED_SIZE
		SDL_GL_ACCUM_GREEN_SIZE
		SDL_GL_ACCUM_BLUE_SIZE
		SDL_GL_ACCUM_ALPHA_SIZE
		SDL_GL_STEREO
		SDL_GL_MULTISAMPLEBUFFERS
		SDL_GL_MULTISAMPLESAMPLES
		SDL_GL_ACCELERATED_VISUAL
		SDL_GL_SWAP_CONTROL
	)],
);

use constant{
	SDL_SWSURFACE    => 0x00000000, # for SDL::Surface->new() and set_video_mode()
	SDL_HWSURFACE    => 0x00000001, # for SDL::Surface->new() and set_video_mode()
	SDL_ASYNCBLIT    => 0x00000004, # for SDL::Surface->new() and set_video_mode()
	SDL_ANYFORMAT    => 0x10000000, # set_video_mode()
	SDL_HWPALETTE    => 0x20000000, # set_video_mode()
	SDL_DOUBLEBUF    => 0x40000000, # set_video_mode()
	SDL_FULLSCREEN   => 0x80000000, # set_video_mode()
	SDL_OPENGL       => 0x00000002, # set_video_mode()
	SDL_OPENGLBLIT   => 0x0000000A, # set_video_mode()
	SDL_RESIZABLE    => 0x00000010, # set_video_mode()
	SDL_NOFRAME      => 0x00000020, # set_video_mode()
	SDL_HWACCEL      => 0x00000100, # set_video_mode()
	SDL_SRCCOLORKEY  => 0x00001000, # set_video_mode()
	SDL_RLEACCELOK   => 0x00002000, # set_video_mode()
	SDL_RLEACCEL     => 0x00004000, # set_video_mode()
	SDL_SRCALPHA     => 0x00010000, # set_video_mode()
	SDL_PREALLOC     => 0x01000000, # set_video_mode()

	SDL_YV12_OVERLAY => 0x32315659, # Planar mode: Y + V + U  (3 planes)
	SDL_IYUV_OVERLAY => 0x56555949, # Planar mode: Y + U + V  (3 planes)
	SDL_YUY2_OVERLAY => 0x32595559, # Packed mode: Y0+U0+Y1+V0 (1 plane)
	SDL_UYVY_OVERLAY => 0x59565955, # Packed mode: U0+Y0+V0+Y1 (1 plane)
	SDL_YVYU_OVERLAY => 0x55595659, # Packed mode: Y0+V0+Y1+U0 (1 plane)

	SDL_LOGPAL       => 0x01,       # for set_palette()
	SDL_PHYSPAL      => 0x02,       # for set_palette()
	
	SDL_GRAB_QUERY      => -1,      # SDL_GrabMode
	SDL_GRAB_OFF        => 0,       # SDL_GrabMode
	SDL_GRAB_ON         => 1,       # SDL_GrabMode
	SDL_GRAB_FULLSCREEN	=> 2,       # SDL_GrabMode, used internally
};

use constant {
	SDL_GL_RED_SIZE                                     => 0,
	SDL_GL_GREEN_SIZE                                   => 1,
	SDL_GL_BLUE_SIZE                                    => 2,
	SDL_GL_ALPHA_SIZE                                   => 3,
	SDL_GL_BUFFER_SIZE                                  => 4,
	SDL_GL_DOUBLEBUFFER                                 => 5,
	SDL_GL_DEPTH_SIZE                                   => 6,
	SDL_GL_STENCIL_SIZE                                 => 7,
	SDL_GL_ACCUM_RED_SIZE                               => 8,
	SDL_GL_ACCUM_GREEN_SIZE                             => 9,
	SDL_GL_ACCUM_BLUE_SIZE                              => 10,
	SDL_GL_ACCUM_ALPHA_SIZE                             => 11,
	SDL_GL_STEREO                                       => 12,
	SDL_GL_MULTISAMPLEBUFFERS                           => 13,
	SDL_GL_MULTISAMPLESAMPLES                           => 14,
	SDL_GL_ACCELERATED_VISUAL                           => 15,
	SDL_GL_SWAP_CONTROL                                 => 16,
}; # SDL_GLattr


# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;

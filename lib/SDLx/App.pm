package SDLx::App;

use strict;
use warnings;

# SDL modules actually used here
use SDL ();
use SDL::Video ();
use SDL::Mouse ();
use SDL::Event ();
use SDL::Surface ();
use SDL::VideoInfo ();
use SDLx::Validate ();
use base qw/SDLx::Surface SDLx::Controller/;

# SDL modules used for other reasons
# Please verify their usefulness here
use SDL::Rect ();
use SDL::Events ();
use SDL::PixelFormat ();

use Carp ();
use Scalar::Util qw/refaddr/;

my %_stash;
my $_screen_w;
my $_screen_h;
my $_screen_d;

$SDLx::App::USING_OPENGL = 0;

sub new {
	my $class = shift;

	my %o = @_;

	# undef is not a valid input
	my $w   = defined $o{width}      ? $o{width}      : defined $o{w}   ? $o{w}   : 640;
	my $h   = defined $o{height}     ? $o{height}     : defined $o{h}   ? $o{h}   : 480;
	my $d   = defined $o{depth}      ? $o{depth}      : defined $o{d}   ? $o{d}   : undef;
	my $f   = defined $o{flags}      ? $o{flags}      : defined $o{f}   ? $o{f}   : 0;
	my $pos = defined $o{position}   ? $o{position}   : defined $o{pos} ? $o{pos} : undef;
	my $ico =                          $o{icon};

	# undef is a valid input
	my $t    =                         $o{title};
	my $it   =                         $o{icon_title};
	my $init = exists $o{initialize} ? $o{initialize}                             : $o{init};
	my $s    = exists $o{stash}      ? $o{stash}                                  : {};
	my $icc  =                         $o{icon_color_key};

	# boolean
	my $sw    = $o{software_surface}  || $o{sw_surface}  || $o{sw};
	my $hw    = $o{hardware_surface}  || $o{hw_surface}  || $o{hw};
	my $ab    = $o{asynchronous_blit} || $o{async_blit};
	my $af    = $o{any_format};
	my $hwp   = $o{hardware_palette}  || $o{hw_palette};
	my $db    = $o{double_buffer}     || $o{double_buf}  || $o{dbl_buf};
	my $fs    = $o{full_screen}       || $o{fullscreen}  || $o{full};
	my $gl    = $o{open_gl}           || $o{opengl}      || $o{gl};
	my $rs    = $o{resizable}         || $o{resizeable}; # it's a hard word to spell :-)
	my $nf    = $o{no_frame};
	my $ncur  = $o{hide_cursor}       || $o{no_cursor};
	my $cen   = $o{centered}          || $o{center};
	my $gi    = $o{grab_input};
	my $nc    = $o{no_controller};

	unless ( defined $d ) {
		# specify SDL_ANYFORMAT flag if depth isn't defined
		$d = 32;
		$af = 1;
	}

	# used to say unless no_init here. I don't think we need it anymore
	if( !defined $init ) {
		SDLx::App->init( SDL::SDL_INIT_EVERYTHING );
	}
	else {
		if( ref $init ) {
			push @$init, "video";
		}
		else {
			$init |= SDL::SDL_INIT_VIDEO;
		}
		SDLx::App->init( $init );
	}

	# keep the screen's original res so we can set the app to that when we're done
	unless(defined $_screen_w && defined $_screen_h && defined $_screen_d) {
		my $video_info = SDL::Video::get_video_info();
		if($video_info) {
			$_screen_w = $video_info->current_w;
			$_screen_h = $video_info->current_h;
			$_screen_d = $video_info->vfmt->BitsPerPixel;
		}
	}

	$f |= SDL::Video::SDL_SWSURFACE  if $sw;
	$f |= SDL::Video::SDL_HWSURFACE  if $hw;
	$f |= SDL::Video::SDL_ASYNCBLIT  if $ab;
	$f |= SDL::Video::SDL_ANYFORMAT  if $af;
	$f |= SDL::Video::SDL_HWPALETTE  if $hwp;
	$f |= SDL::Video::SDL_DOUBLEBUF  if $db;
	$f |= SDL::Video::SDL_FULLSCREEN if $fs;
	$f |= SDL::Video::SDL_OPENGL     if $gl;
	$f |= SDL::Video::SDL_RESIZABLE  if $rs;
	$f |= SDL::Video::SDL_NOFRAME    if $nf;

	# we'll let SDL decide which takes priority and set both if both are specified
	$ENV{SDL_VIDEO_CENTERED}   = $cen if $cen;
	$ENV{SDL_VIDEO_WINDOW_POS} = $pos if $pos;

	if ( $gl ) {
		$SDLx::App::USING_OPENGL = 1;

		my $r   = defined $o{gl_red_size}             ? $o{gl_red_size}             : defined $o{gl_red}         ? $o{gl_red}         : 5;
		my $g   = defined $o{gl_green_size}           ? $o{gl_green_size}           : defined $o{gl_green}       ? $o{gl_green}       : 5;
		my $b   = defined $o{gl_blue_size}            ? $o{gl_blue_size}            : defined $o{gl_blue}        ? $o{gl_blue}        : 5;
		my $a   = defined $o{gl_alpha_size}           ? $o{gl_alpha_size}           : defined $o{gl_alpha}       ? $o{gl_alpha}       : undef;
		my $ra  = defined $o{gl_accum_red_size}       ? $o{gl_accum_red_size}       : defined $o{gl_accum_red}   ? $o{gl_accum_red}   : undef;
		my $ga  = defined $o{gl_accum_green_size}     ? $o{gl_accum_green_size}     : defined $o{gl_accum_green} ? $o{gl_accum_green} : undef;
		my $ba  = defined $o{gl_accum_blue_size}      ? $o{gl_accum_blue_size}      : defined $o{gl_accum_blue}  ? $o{gl_accum_blue}  : undef;
		my $aa  = defined $o{gl_accum_alpha_size}     ? $o{gl_accum_alpha_size}     : defined $o{gl_accum_alpha} ? $o{gl_accum_alpha} : undef;
		my $bs  = defined $o{gl_buffer_size}          ? $o{gl_buffer_size}          : defined $o{gl_buffer}      ? $o{gl_buffer}      : undef;
		my $ss  = defined $o{gl_stencil_size}         ? $o{gl_stencil_size}         : defined $o{gl_stencil}     ? $o{gl_stencil}     : undef;
		my $msb = defined $o{gl_multi_sample_buffers} ? $o{gl_multi_sample_buffers}                                                   : undef;
		my $mss = defined $o{gl_multi_sample_samples} ? $o{gl_multi_sample_samples}                                                   : undef;

		# boolean
		my $s  = $o{gl_stereo};
		my $sc = $o{gl_swap_control};
		my $av = $o{gl_accelerated_visual};

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_RED_SIZE,   $r ) if defined $r;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_GREEN_SIZE, $g ) if defined $g;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_BLUE_SIZE,  $b ) if defined $b;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ALPHA_SIZE, $a ) if defined $a;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCUM_RED_SIZE,   $ra ) if defined $ra;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCUM_GREEN_SIZE, $ga ) if defined $ga;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCUM_BLUE_SIZE,  $ba ) if defined $ba;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCUM_ALPHA_SIZE, $aa ) if defined $aa;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_BUFFER_SIZE,  $bs ) if defined $bs;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_DOUBLEBUFFER, $db ) if defined $db;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_DEPTH_SIZE,   $d  );
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_STENCIL_SIZE, $ss ) if defined $ss;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_STEREO,             $s   ) if defined $s;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_MULTISAMPLEBUFFERS, $msb ) if defined $msb;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_MULTISAMPLESAMPLES, $mss ) if defined $mss;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_SWAP_CONTROL,       $sc  ) if defined $sc;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCELERATED_VISUAL, $av  ) if defined $av;
	}

	# icon must be set before set_video_mode
	SDLx::App->icon( $ico, $icc ) if defined $ico;

	my $self = $class->set_video_mode( $w, $h, $d, $f );
	$self->SDLx::Controller::new( %o ) unless $nc;

	$t = defined $it ? $it : $0 unless defined $t;
	$it = $t unless defined $it;
	$self->title( $t, $it );

	$self->show_cursor( 0 ) if $ncur;
	$self->grab_input( $gi ) if $gi;
	$self->stash = $s;

	$self;
}

sub set_video_mode {
	my ( $self, $w, $h, $d, $f ) = @_;
	my $surface = SDL::Video::set_video_mode( $w, $h, $d, $f )
		or Carp::confess( "set_video_mode failed: ", SDL::get_error() );
	$surface = SDLx::Surface->new( surface => $surface );

	# if we already have an app
	if( ref $self ) {
		return $self;
	}
	return bless $surface, $self;
}

sub DESTROY {
	my ( $self ) = @_;

	# set original screen size when app ends
	if(defined $_screen_w && defined $_screen_h && defined $_screen_d) {
		SDL::Video::set_video_mode( $_screen_w, $_screen_h, $_screen_d, $self->flags );
	}

	my $ref = refaddr($self);
	delete $_stash{ $ref };
}

sub stash :lvalue {
	$_stash{ refaddr( $_[0] ) };
}

sub init {
	my ( undef, $init ) = @_;

	if ( ref $init ) {
		# make a hash with keys of the values in the init array
		my %init = map { $_ => 1 } @$init;
		undef $init;

		$init |= SDL::SDL_INIT_TIMER       if $init{timer};
		$init |= SDL::SDL_INIT_AUDIO       if $init{audio};
		$init |= SDL::SDL_INIT_VIDEO       if $init{video};
		$init |= SDL::SDL_INIT_CDROM       if $init{cd_rom}       || $init{cdrom};
		$init |= SDL::SDL_INIT_JOYSTICK    if $init{joystick};
		$init |= SDL::SDL_INIT_EVERYTHING  if $init{everything}   || $init{all};
		$init |= SDL::SDL_INIT_NOPARACHUTE if $init{no_parachute};
		$init |= SDL::SDL_INIT_EVENTTHREAD if $init{event_thread};
	}

	# if anything is already inited, only init specified extra subsystems
	if ( SDL::was_init( SDL::SDL_INIT_EVERYTHING ) ) {
		SDL::init_sub_system( $init )
			and Carp::cluck( "SDL init_sub_system failed: ", SDL::get_error() );
	}
	else {
		SDL::init( $init )
			and Carp::confess( "SDL init failed: ", SDL::get_error() );
	}
}

sub screen_size {
	SDLx::App->init( SDL::SDL_INIT_VIDEO );

	my $video_info = SDL::Video::get_video_info();

	return( $video_info->current_w, $video_info->current_h, $video_info->vfmt->BitsPerPixel );
}

sub resize {
	my ( $self, $w, $h ) = @_;

	my $d = $self->format->BitsPerPixel;
	my $f = $self->flags;

	$self->set_video_mode( $w, $h, $d, $f );
}

sub title {
	my ( $self, $title, $icon_title ) = @_;
	my $video_info = SDL::Video::get_video_info();
	return if $video_info && !$video_info->wm_available();

	if ( @_ > 1 ) {
		my ($t, $it) = SDL::Video::wm_get_caption;
		$title      = $t  unless defined $title;
		$icon_title = $it unless defined $icon_title;
		return SDL::Video::wm_set_caption( $title, $icon_title );
	}
	SDL::Video::wm_get_caption;
}

sub icon {
	my ( undef, $icon, $color ) = @_;
	SDLx::App->init( SDL::SDL_INIT_VIDEO );
	unless( UNIVERSAL::isa( $icon, "SDL::Surface" ) ) {
		$icon = SDL::Video::load_BMP( $icon );
		$icon or Carp::confess( "Could not load_BMP icon '$icon': ", SDL::get_error() );
	}
	if( defined $color ) {
		$color = SDLx::Validate::map_rgb( $color, $icon->format );
		SDL::Video::set_color_key( $icon, SDL::Video::SDL_SRCCOLORKEY, $color );
	}
	SDL::Video::wm_set_icon( $icon );
}

sub error {
	shift;
	if ( @_ == 1 and !defined $_[0] ) {
		return SDL::clear_error;
	}
	if ( @_ ) {
		return SDL::set_error_real( @_ );
	}
	SDL::get_error;
}

sub warp_cursor {
	my ( undef, $x, $y ) = @_;
	SDL::Mouse::warp_mouse( $x || 0, $y || 0 );
}

sub show_cursor {
	my ( undef, $show ) = @_;
	if ( @_ > 1 ) {
		return SDL::Mouse::show_cursor( SDL::Event::SDL_ENABLE ) if $show and $show ne SDL::Event::SDL_QUERY;
		return SDL::Mouse::show_cursor( SDL::Event::SDL_DISABLE ) unless $show;
	}
	SDL::Mouse::show_cursor( SDL::Event::SDL_QUERY );
}

sub fullscreen {
	my ( $self ) = @_;
	return 1 if SDL::Video::wm_toggle_fullscreen( $self );

	# fallback to doing it with set_video_mode()
	my $d = $self->format->BitsPerPixel;
	my $f = $self->flags;

	eval { $self->set_video_mode( 0, 0, $d, $f ^ SDL::Video::SDL_FULLSCREEN ) };
	return 1 unless $@;

	# failed going fullscreen, let's revert back
	$self->set_video_mode( 0, 0, $d, $f );

	# report failure to go fullscreen
	return 0;
}

sub iconify {
	SDL::Video::wm_iconify_window;
}

sub grab_input {
	my ( undef, $grab ) = @_;
	if (@_ > 1) {
		return SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_ON ) if $grab and $grab ne SDL::Video::SDL_GRAB_QUERY;
		return SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_OFF ) unless $grab;
	}
	SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_QUERY );
}

sub sync {
	my ( $self ) = @_;
	if ( $SDLx::App::USING_OPENGL ) {
		return SDL::Video::GL_swap_buffers;
	}
	SDL::Video::flip( $self );
}

sub gl_attribute {
	my ( undef, $mode, $value ) = @_;

	return unless $SDLx::App::USING_OPENGL;
	if ( @_ > 2 ) {
		return SDL::Video::GL_set_attribute( $mode, $value );
	}
	my $returns = SDL::Video::GL_get_attribute( $mode );
	Carp::cluck( "SDL::Video::GL_get_attribute failed to get GL attribute" )
		if $returns->[0] < 0;
	$returns->[1];
}

1;

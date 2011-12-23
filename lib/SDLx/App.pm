package SDLx::App;

use strict;
use warnings;

# SDL modules actually used here
use SDL ();
use SDL::Video ();
use SDL::Mouse ();
use base qw/SDLx::Surface SDLx::Controller/;

# SDL modules used for other reasons
# Please verify their usefulness here
use SDL::Rect ();
use SDL::Event ();
use SDL::Events ();
use SDL::Surface ();
use SDL::PixelFormat ();

use Carp ();
use Scalar::Util qw/refaddr/;

my %_stash;

sub new {
	my $class = shift;
	$class = ref $class || $class;
	my %o = @_;

	# undef is not a valid input
	my $w   = defined $o{width}            ? $o{width}            : defined $o{w}   ? $o{w}   : 640;
	my $h   = defined $o{height}           ? $o{height}           : defined $o{h}   ? $o{h}   : 480;
	my $d   = defined $o{depth}            ? $o{depth}            : defined $o{d}   ? $o{d}   : undef;
	my $f   = defined $o{flags}            ? $o{flags}            : defined $o{f}   ? $o{f}   : 0;
	my $pos = defined $o{position}         ? $o{position}         : defined $o{pos} ? $o{pos} : undef;
	my $s   = defined $o{stash}            ? $o{stash}            : defined $o{s}   ? $o{s}   : {};

	# undef is a valid input
	my $t    = exists $o{title}            ? $o{title}            : exists  $o{t}   ? $o{t}   : undef;
	my $it   = exists $o{icon_title}       ? $o{icon_title}       : exists  $o{it}  ? $o{it}  : undef;
	my $icon =                                                                        $o{icon};
	my $init =                                                                        $o{init};

	# boolean
	my $af    = $o{any_format}    || $o{af};
	my $db    = $o{double_buf}    || $o{db};
	my $sw    = $o{sw_surface}    || $o{sw};
	my $hw    = $o{hw_surface}    || $o{hw};
	my $ab    = $o{async_blit}    || $o{ab};
	my $hwp   = $o{hw_palette}    || $o{hwp};
	my $fs    = $o{fullscreen}    || $o{fs};
	my $gl    = $o{opengl}        || $o{gl};
	my $rs    = $o{resizable}     || $o{rs};
	my $nf    = $o{no_frame}      || $o{nf};
	my $ncur  = $o{no_cursor}     || $o{ncur};
	my $cen   = $o{centered}      || $o{cen};
	my $gi    = $o{grab_input}    || $o{gi};
	my $nc    = $o{no_controller} || $o{nc};
	
	unless ( defined $d ) {
		# specify SDL_ANYFORMAT if depth isn't defined
		$d = 32;
		$af = 1;
	}

	#used to say unless no_init here. I don't think we need it anymore
	if ( ref $init eq 'ARRAY' ) {
		my %init = map { $_ => 1 } @$init;
		undef $init;
		$init |= SDL::SDL_INIT_AUDIO       if $init{audio}        || $init{a};
		$init |= SDL::SDL_INIT_VIDEO       if $init{video}        || $init{v};
		$init |= SDL::SDL_INIT_CDROM       if $init{cd_rom}       || $init{cd};
		$init |= SDL::SDL_INIT_EVERYTHING  if $init{everything}   || $init{e};
		$init |= SDL::SDL_INIT_NOPARACHUTE if $init{no_parachute} || $init{np};
		$init |= SDL::SDL_INIT_JOYSTICK    if $init{joystick}     || $init{j};
		$init |= SDL::SDL_INIT_TIMER       if $init{timer}        || $init{t};
	}
	#if anything is already inited, only init specified extra subsystems
	if ( SDL::was_init( SDL::SDL_INIT_EVERYTHING ) & (SDL::SDL_INIT_AUDIO | SDL::SDL_INIT_CDROM | SDL::SDL_INIT_EVENTTHREAD | SDL::SDL_INIT_JOYSTICK | SDL::SDL_INIT_TIMER | SDL::SDL_INIT_VIDEO) ) {
		SDL::init_sub_system( $init ) if defined $init;
	}
	else {
		SDL::init( defined $init ? $init : SDL::SDL_INIT_EVERYTHING );
	}
	
	$f |= SDL::Video::SDL_ANYFORMAT  if $af;
	$f |= SDL::Video::SDL_DOUBLEBUF  if $db;
	$f |= SDL::Video::SDL_SWSURFACE  if $sw;
	$f |= SDL::Video::SDL_HWSURFACE  if $hw;
	$f |= SDL::Video::SDL_ASYNCBLIT  if $ab;
	$f |= SDL::Video::SDL_HWPALETTE  if $hwp;
	$f |= SDL::Video::SDL_FULLSCREEN if $fs;
	$f |= SDL::Video::SDL_OPENGL     if $gl;
	$f |= SDL::Video::SDL_RESIZABLE  if $rs;
	$f |= SDL::Video::SDL_NOFRAME    if $nf;

	#we'll let SDL decide which takes priority and set both if both are specified
	$ENV{SDL_VIDEO_CENTERED}   = $cen if $cen;
	$ENV{SDL_VIDEO_WINDOW_POS} = $pos if $pos;

	my $surface = SDL::Video::set_video_mode( $w, $h, $d, $f ) or Carp::confess( "set_video_mode failed: ", SDL::get_error() );
	my $self = SDLx::Surface->new( surface => $surface );
	$self->SDLx::Controller::new( %o ) unless $nc;
	bless $self, $class;

	if ( $gl ) {
		$SDLx::App::USING_OPENGL = 1;
		
		my $r   = defined $o{red_size}         ? $o{red_size}         : defined $o{r}  ? $o{r}  : 5;
		my $g   = defined $o{green_size}       ? $o{green_size}       : defined $o{g}  ? $o{g}  : 5;
		my $b   = defined $o{blue_size}        ? $o{blue_size}        : defined $o{b}  ? $o{b}  : 5;
		my $a   = defined $o{alpha_size}       ? $o{alpha_size}       : defined $o{a}  ? $o{a}  : undef;
		my $ra  = defined $o{red_accum_size}   ? $o{red_accum_size}   : defined $o{ra} ? $o{ra} : undef;
		my $ga  = defined $o{green_accum_size} ? $o{green_accum_size} : defined $o{ga} ? $o{ga} : undef;
		my $ba  = defined $o{blue_accum_size}  ? $o{blue_accum_size}  : defined $o{ba} ? $o{ba} : undef;
		my $aa  = defined $o{alpha_accum_size} ? $o{alpha_accum_size} : defined $o{aa} ? $o{aa} : undef;
		my $bs  = defined $o{buffer_size}      ? $o{buffer_size}      : defined $o{bs} ? $o{bs} : undef;
		my $ss  = defined $o{stencil_size}     ? $o{stencil_size}     : defined $o{ss} ? $o{ss} : undef;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_RED_SIZE,   $r );
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_GREEN_SIZE, $g );
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_BLUE_SIZE,  $b );
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ALPHA_SIZE, $a ) if defined $a;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_RED_ACCUM_SIZE(),   $ra ) if defined $ra;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_GREEN_ACCUM_SIZE(), $ga ) if defined $ga;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_BLUE_ACCUM_SIZE(),  $ba ) if defined $ba;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ALPHA_ACCUM_SIZE(), $aa ) if defined $aa;

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_DEPTH_SIZE,   $d  );
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_DOUBLEBUFFER, $db ) if defined $db;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_BUFFER_SIZE,  $bs ) if defined $bs;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_STENCIL_SIZE, $ss ) if defined $ss;

		# These could be added here?
		# SDL_GL_STEREO
		# SDL_GL_MULTISAMPLEBUFFERS
		# SDL_GL_MULTISAMPLESAMPLES
		# SDL_GL_ACCELERATED_VISUAL
		# SDL_GL_SWAP_CONTROL
	}
	else {
		$SDLx::App::USING_OPENGL = 0;
	}

	$self->title( $t, $it );
	$self->icon( $icon );
	$self->show_cursor( 0 ) if $ncur;
	$self->grab_input( $gi ) if $gi;
	$self->stash = $s;

	$self;
}

sub DESTROY {
	my ($self) = @_;
	my $ref = refaddr($self);
	delete $_stash{ $ref };
}

sub stash :lvalue {
	return $_stash{ refaddr( $_[0] ) };
}

sub resize {
	my ($self, $w, $h) = @_;
	my $flags = $self->flags;
	if ( $flags & SDL::Video::SDL_RESIZABLE ) {
		my $d = $self->format->BitsPerPixel;
		return $self = SDL::Video::set_video_mode( $w, $h, $d, $flags )
			or Carp::confess( "SDL cannot set video:" . SDL::get_error );
	}
	Carp::confess( "Application surface not resizable" );
}

sub title {
	my ( undef, $title, $icon_title ) = @_;
	if ( @_ > 1 ) {
		$title = defined $icon_title ? $icon_title : $0 unless defined $title;
		$icon_title = $title unless defined $icon_title;
		return SDL::Video::wm_set_caption( $title, $icon_title );
	}
	SDL::Video::wm_get_caption;
}

sub icon {
	SDL::Video::wm_set_icon( $_[1] );
}

# this has been moved to SDLx::Controller in the form of time and sleep
# this can be removed at any time we wanna break compat
sub delay {
	SDL::delay( $_[1] );
}

sub ticks {
	SDL::get_ticks;
}

sub error {
	shift;
	if ( @_ == 1 and !defined $_[0] ) {
		return SDL::clear_error;
	}
	if ( @_ ) {
		return SDL_set_error_real( @_ );
	}
	SDL::get_error;
}

sub warp {
	my ( undef, $x, $y ) = @_;
	SDL::Mouse::warp_mouse( $x, $y );
}

sub show_cursor {
	my (undef, $show) = @_;
	if ( @_ > 1 ) {
		return SDL::Mouse::show_cursor( SDL::Events::SDL_ENABLE ) if $show;
		return SDL::Mouse::show_cursor( SDL::Events::SDL_DISABLE );
	}
	SDL::Mouse::show_cursor( SDL::Events::SDL_QUERY );
}

sub fullscreen {
	my ( $self ) = @_;
	SDL::Video::wm_toggle_fullscreen( $self );
}

sub iconify {
	SDL::Video::wm_iconify_window;
}

sub grab_input {
	my (undef, $grab ) = @_;
	if (@_ > 1) {
		return SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_ON ) if $grab;
		return SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_OFF );
	}
	SDL::Video::wm_grab_input( SDL::Video::SDL_GRAB_QUERY );
}

sub sync {
	my ( $self ) = @_;
	if ( $SDLx::App::USING_OPENGL ) {
		return SDL::Video::GL_swap_buffers;
	}
	$self->flip;
}

sub attribute {
	my ( undef, $mode, $value ) = @_;
	
	return unless $SDLx::App::USING_OPENGL;
	if ( defined $value ) {
		return SDL::Video::GL_set_attribute( $mode, $value );
	}
	my $returns = SDL::Video::GL_get_attribute( $mode );
	Carp::confess( "SDLx::App::attribute failed to get GL attribute" )
		if ( $returns->[0] < 0 );
	$returns->[1];
}

1;

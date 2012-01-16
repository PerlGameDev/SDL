package SDLx::App;

use strict;
use warnings;

# SDL modules actually used here
use SDL ();
use SDL::Video ();
use SDL::Mouse ();
use SDL::Event ();
use SDL::Surface ();
use base qw/SDLx::Surface SDLx::Controller/;

# SDL modules used for other reasons
# Please verify their usefulness here
use SDL::Rect ();
use SDL::Events ();
use SDL::PixelFormat ();

use Carp ();
use Scalar::Util qw/refaddr/;

my %_stash;

$SDLx::App::USING_OPENGL = 0;

sub new {
	my $class = shift;
	$class = ref $class || $class;
	my %o = @_;

	# undef is not a valid input
	my $w   = defined $o{width}      ? $o{width}      : defined $o{w}   ? $o{w}   : 640;
	my $h   = defined $o{height}     ? $o{height}     : defined $o{h}   ? $o{h}   : 480;
	my $d   = defined $o{depth}      ? $o{depth}      : defined $o{d}   ? $o{d}   : undef;
	my $f   = defined $o{flags}      ? $o{flags}      : defined $o{f}   ? $o{f}   : 0;
	my $pos = defined $o{position}   ? $o{position}   : defined $o{pos} ? $o{pos} : undef;
	my $s   = defined $o{stash}      ? $o{stash}                                  : {};

	# undef is a valid input
	my $t    =                         $o{title};
	my $it   =                         $o{icon_title};
	my $icon =                         $o{icon};
	my $init = exists $o{initialize} ? $o{initialize}                             : $o{init};

	# boolean
	my $af    = $o{any_format};
	my $db    = $o{double_buffer}     || $o{double_buf} || $o{dbl_buf};
	my $sw    = $o{software_surface}  || $o{sw_surface} || $o{sw};
	my $hw    = $o{hardware_surface}  || $o{hw_surface} || $o{hw};
	my $ab    = $o{asynchronous_blit} || $o{async_blit};
	my $hwp   = $o{hardware_palette}  || $o{hw_palette} || $o{hw_pal};
	my $fs    = $o{full_screen}       || $o{fullscreen};
	my $gl    = $o{open_gl}           || $o{opengl}     || $o{gl};
	my $rs    = $o{resizable};
	my $nf    = $o{no_frame};
	my $ncur  = $o{no_cursor};
	my $cen   = $o{centered}          || $o{center};
	my $gi    = $o{grab_input};
	my $nc    = $o{no_controller};

	unless ( defined $d ) {
		# specify SDL_ANYFORMAT flag if depth isn't defined
		$d = 32;
		$af = 1;
	}

	# used to say unless no_init here. I don't think we need it anymore
	if ( ref $init eq 'ARRAY' ) {
		# make a hash with keys of the values in the init array
		my %init = map { $_ => 1 } @$init;
		undef $init;

		$init |= SDL::SDL_INIT_AUDIO       if $init{audio};
		$init |= SDL::SDL_INIT_CDROM       if $init{cd_rom}       || $init{cdrom};
		$init |= SDL::SDL_INIT_EVERYTHING  if $init{everything};
		$init |= SDL::SDL_INIT_NOPARACHUTE if $init{no_parachute};
		$init |= SDL::SDL_INIT_JOYSTICK    if $init{joystick};
		$init |= SDL::SDL_INIT_TIMER       if $init{timer};
	}

	# if anything is already inited, only init specified extra subsystems
	if ( SDL::was_init( SDL::SDL_INIT_AUDIO | SDL::SDL_INIT_CDROM | SDL::SDL_INIT_EVENTTHREAD | SDL::SDL_INIT_JOYSTICK | SDL::SDL_INIT_TIMER | SDL::SDL_INIT_VIDEO ) ) {
		# I'm assuming we always wanna init video
		SDL::init_sub_system( ($init || 0) | SDL::SDL_INIT_VIDEO );
	}
	else {
		# I'm assuming we always wanna init video
		SDL::init( defined $init ? $init | SDL::SDL_INIT_VIDEO : SDL::SDL_INIT_EVERYTHING );
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

	# we'll let SDL decide which takes priority and set both if both are specified
	$ENV{SDL_VIDEO_CENTERED}   = $cen if $cen;
	$ENV{SDL_VIDEO_WINDOW_POS} = $pos if $pos;

	my $surface = SDL::Video::set_video_mode( $w, $h, $d, $f )
		or Carp::confess( "set_video_mode failed: ", SDL::get_error() );
	my $self = bless SDLx::Surface->new( surface => $surface ), $class;
	$self->SDLx::Controller::new( %o ) unless $nc;

	if ( $gl ) {
		$SDLx::App::USING_OPENGL = 1;

		my $r   = defined $o{gl_red_size}             ? $o{gl_red_size}             : defined $o{gl_red}         ? $o{gl_red}         : 5;
		my $g   = defined $o{gl_green_size}           ? $o{gl_green_size}           : defined $o{gl_green}       ? $o{gl_green}       : 5;
		my $b   = defined $o{gl_blue_size}            ? $o{gl_blue_size}            : defined $o{gl_blue}        ? $o{gl_blue}        : 5;
		my $a   = defined $o{gl_alpha_size}           ? $o{gl_alpha_size}           : defined $o{gl_alpha}       ? $o{gl_alpha}       : undef;
		my $ra  = defined $o{gl_red_accum_size}       ? $o{gl_red_accum_size}       : defined $o{gl_red_accum}   ? $o{gl_red_accum}   : undef;
		my $ga  = defined $o{gl_green_accum_size}     ? $o{gl_green_accum_size}     : defined $o{gl_green_accum} ? $o{gl_green_accum} : undef;
		my $ba  = defined $o{gl_blue_accum_size}      ? $o{gl_blue_accum_size}      : defined $o{gl_blue_accum}  ? $o{gl_blue_accum}  : undef;
		my $aa  = defined $o{gl_alpha_accum_size}     ? $o{gl_alpha_accum_size}     : defined $o{gl_alpha_accum} ? $o{gl_alpha_accum} : undef;
		my $bs  = defined $o{gl_buffer_size}          ? $o{gl_buffer_size}          : defined $o{gl_buffer}      ? $o{gl_buffer}      : undef;
		my $ss  = defined $o{gl_stencil_size}         ? $o{gl_stencil_size}         : defined $o{gl_stencil}     ? $o{gl_stencil}     : undef;
		my $msb = defined $o{gl_multi_sample_buffers} ? $o{gl_multi_sample_buffers}                                                   : undef;
		my $mss = defined $o{gl_multi_sample_samples} ? $o{gl_multi_sample_samples}                                                   : undef;

		# boolean
		my $s  = $o{gl_stereo};
		my $sc = $o{gl_swap_control};
		my $av = $o{gl_accelerated_visual};

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

		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_STEREO,             $s   ) if defined $s;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_MULTISAMPLEBUFFERS, $msb ) if defined $msb;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_MULTISAMPLESAMPLES, $mss ) if defined $mss;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_SWAP_CONTROL,       $sc  ) if defined $sc;
		SDL::Video::GL_set_attribute( SDL::Video::SDL_GL_ACCELERATED_VISUAL, $av  ) if defined $av;
	}

	$self->title( $t, $it );
	$self->icon( $icon );
	$self->show_cursor( 0 ) if $ncur;
	$self->grab_input( $gi ) if $gi;
	$self->stash = $s;

	$self;
}

sub DESTROY {
	my ( $self ) = @_;
	my $ref = refaddr($self);
	delete $_stash{ $ref };
}

sub stash :lvalue {
	return $_stash{ refaddr( $_[0] ) };
}

sub resize {
	my ( $self, $w, $h, $d, $flags ) = @_;
	
	# you'd probably never need to change the depth or flags, but we offer it because why not
	$d = $self->format->BitsPerPixel unless defined $d;
	$flags = $self->flags unless defined $flags;

	# do what we do in new() to make the app object
	my $surface = SDL::Video::set_video_mode( $w, $h, $d, $flags )
		or Carp::confess( "resize with set_video_mode failed: ", SDL::get_error() );
	$surface = bless SDLx::Surface->new( surface => $surface ), ref $self;
	
	# make $self point to the new C surface object
	# luckily, we keep the app's SDLx::Controller like this
	# because its inside-out-ness pays attention to the address of the SV and not the C object
	$$self = $$surface;

	$self;
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

sub warp_cursor {
	my ( undef, $x, $y ) = @_;
	SDL::Mouse::warp_mouse( $x, $y );
}

sub show_cursor {
	my ( undef, $show ) = @_;
	if ( @_ > 1 ) {
		return SDL::Mouse::show_cursor( SDL::Event::SDL_ENABLE ) if $show;
		return SDL::Mouse::show_cursor( SDL::Event::SDL_DISABLE );
	}
	SDL::Mouse::show_cursor( SDL::Event::SDL_QUERY );
}

sub fullscreen {
	my ( $self ) = @_;
	SDL::Video::wm_toggle_fullscreen( $self );
}

sub iconify {
	SDL::Video::wm_iconify_window;
}

sub grab_input {
	my ( undef, $grab ) = @_;
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

sub gl_attribute {
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

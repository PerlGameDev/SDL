package SDLx::Text;
use SDL;
use SDL::Video;
use SDL::Config;
use SDL::TTF;
use SDL::TTF::Font;
use SDLx::Validate;

use Carp ();

sub new {
	my ($class, %options) = @_;
	unless ( SDL::Config->has('SDL_ttf') ) {
		Carp::cluck("SDL_ttf support has not been compiled");
	}  
	my $file = $options{'font'};
    if (!$file) {
        require File::ShareDir;
        $file = File::ShareDir::dist_file('SDL', 'GenBasR.ttf');
    }

	my $color = $options{'color'} || [255, 255, 255];

	my $size = $options{'size'} || 24;

	my $self = bless {}, ref($class) || $class;

	$self->{x} = $options{'x'} || 0;
	$self->{y} = $options{'y'} || 0;

	$self->{h_align} = $options{'h_align'} || 'left';
# TODO: validate
# TODO: v_align
	unless ( SDL::TTF::was_init() ) {
		Carp::cluck ("Cannot init TTF: " . SDL::get_error() )
		    unless SDL::TTF::init() == 0;
	}

	$self->size($size);
	$self->font($file);
	$self->color($color);

	$self->text( $options{'text'} ) if defined $options{'text'};

	return $self;
}

sub font {
	my ($self, $font) = @_;

	if ($font) {
		my $size = $self->size;

		$self->{_font} = SDL::TTF::open_font($font, $size)
			or Carp::cluck 'Error opening font: ' . SDL::get_error;
	}

	return $self->{_font};
}

sub color {
	my ($self, $color) = @_;

	if ($color) {
		$self->{_color} = SDLx::Validate::color($color);
	}

	return $self->{_color};
}

sub size {
	my ($self, $size) = @_;

	if ($size) {
		$self->{_size} = $size;

		# reload the font using new size
		$self->font( $self->font );
	}

	return $self->{_size};
}

sub h_align {
	my ($self, $align) = @_;

	if ($align) {
		$self->{h_align} = $align;
	}

	return $self->{h_align};
}


sub w {
	return $_[0]->{surface}->w();
}

sub h {
	return $_[0]->{surface}->h();
}

sub x {
	my ($self, $x) = @_;

	if ($x) {
		$self->{x} = $x;
	}
	return $self->{x};
}

sub y {
	my ($self, $y) = @_;

	if ($y) {
		$self->{y} = $y;
	}
	return $self->{y};
}

sub text {
	my ($self, $text) = @_;

	my $surface;

	$surface = SDL::TTF::render_utf8_blended($self->{_font}, $text, $self->{_color})
		or Carp::croak 'TTF rendering error: ' . SDL::get_error;

	$self->{surface} = $surface;
	my $arr =  SDL::TTF::size_utf8( $self->{_font}, $text );
	$self->{w} = $arr->[0];
	$self->{h} = $arr->[1];

	return $self;
}

sub surface {
	return $_[0]->{surface};
}

sub write_to {
	my ($self, $target, $text) = @_;

	$self->text($text) if $text;
	if ( my $surface = $self->{surface} ) {
		if ($self->{h_align} eq 'center' ) {
			$self->{x} = ($target->w / 2) - ($surface->w / 2);
		}
		# TODO: other alignments

		SDL::Video::blit_surface(
			$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
			$target, SDL::Rect->new($self->{x}, $self->{y}, $target->w, $target->h)
		);
	}
	return;
}

sub write_xy {
	my ($self, $target, $x, $y, $text) = @_;

	$self->text($text) if $text;
	if ( my $surface = $self->{surface} ) {

		SDL::Video::blit_surface(
				$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
				$target, SDL::Rect->new($x, $y, $target->w, $target->h)
		);
	}
	return;
}

1;

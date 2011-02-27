package SDLx::Text;
use SDL;
use SDL::Video;
use SDL::Config;
use SDL::TTF;
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
        $file = File::ShareDir::dist_file('SDL', 'GenBasB.ttf');
    }

	my $color = $options{'color'} || [255, 0, 0];

	$color = SDLx::Validate::color($color);

	my $size = $options{'size'} || 24;

	my $self = bless {}, ref($class) || $class;

	$self->{x} = $options{'x'} || 0;
	$self->{y} = $options{'y'} || 0;

	$self->{h_align} = $options{'h_align'} || 'left';
# TODO: validate
# TODO: v_align
# TODO: other accessors
	unless ( SDL::TTF::was_init() )
	{
		Carp::cluck ("Cannot init TTF: " . SDL::get_error() ) unless SDL::TTF::init() == 0;
	}
	$self->{_font} = SDL::TTF::open_font($file, $size);
	Carp::cluck 'Error opening font: ' . SDL::get_error
		unless $self->{_font};

	$self->{_color} = $color;

	return $self;
}

sub w {
	return $_[0]->{surface}->w();
}

sub h {
	return $_[0]->{surface}->h();
}

sub text {
	my ($self, $text) = @_;

	my $surface;

	unless ($self->{mode}){
		$surface = SDL::TTF::render_text_blended($self->{_font}, $text, $self->{_color})
		or Carp::croak 'TTF rendering error: ' . SDL::get_error;

	}	
	elsif( $self->{mode} =~ 'utf8' )
	{
		$surface = SDL::TTF::render_utf8_blended($self->{_font}, $text, $self->{_color})
		or Carp::croak 'TTF rendering error: ' . SDL::get_error;

	}
	elsif ( $self->{mode} =~ 'unicode' )
	{
	$surface = SDL::TTF::render_unicode_blended($self->{_font}, $text, $self->{_color})
		or Carp::croak 'TTF rendering error: ' . SDL::get_error;

	}
	$self->{surface} = $surface;
	$self->{w} = $surface->w;
	$self->{h} = $surface->h;

	return $surface;
}

sub write_to {
	my ($self, $target, $text) = @_;

	$self->text($text) if $text;

	my $surface = $self->{surface};

	if ($self->{h_align} eq 'center' ) {
		$self->{x} = ($target->w / 2) - ($surface->w / 2);
	}
# TODO: other alignments

	SDL::Video::blit_surface(
			$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
			$target, SDL::Rect->new($self->{x}, $self->{y}, $target->w, $target->h)
			);
	return;
}

sub write_xy {
	my ($self, $target, $x, $y, $text) = @_;

	$self->text($text) if $text;
	my $surface = $self->{surface};

	SDL::Video::blit_surface(
			$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
			$target, SDL::Rect->new($x, $y, $target->w, $target->h)
			);
	return;
}

1;

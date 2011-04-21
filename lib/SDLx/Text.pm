package SDLx::Text;
use SDL;
use SDL::Video;
use SDL::Config;
use SDL::TTF;
use SDL::TTF::Font;
use SDL::Rect;
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

    Carp::confess 'rect cannot be instantiated together with x or y'
        if exists $options{rect} and ( exists $options{x} or exists $options{y} );

    my $color = $options{'color'} || [255, 255, 255];

    my $size = $options{'size'} || 24;

    my $self = bless {}, ref($class) || $class;

    $self->x( $options{x} || 0 );
    $self->y( $options{y} || 0 );
    $self->rect( $options{rect} ) if exists $options{rect};
    $self->clip( $options{clip} ) if exists $options{clip};

    $self->h_align($options{'h_align'} || 'left');
    $self->v_align($options{'v_align'} || 'top');
# TODO: validate
    unless ( SDL::TTF::was_init() ) {
        Carp::cluck ("Cannot init TTF: " . SDL::get_error() )
            unless SDL::TTF::init() == 0;
    }

    $self->size($size);
    $self->font($file);
    $self->color($color);

    $self->text( $options{'text'} ) if exists $options{'text'};

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

sub v_align {
    my ($self, $align) = @_;

    if ($align) {
        $self->{v_align} = $align;
    }

    return $self->{v_align};
}


sub w {
    return $_[0]->{surface}->w();
}

sub h {
    return $_[0]->{surface}->h();
}

sub x {
    my ($self, $x) = @_;

    if (defined $x) {
        $self->{x} = $x;
    }
    return $self->{x};
}

sub y {
    my ($self, $y) = @_;

    if (defined  $y) {
        $self->{y} = $y;
    }
    return $self->{y};
}

sub text {
    my ($self, $text) = @_;

    return $self->{text} if scalar @_ == 1;

    $self->{text} = $text;

    if ( defined $text ) {
        my $surface = SDL::TTF::render_utf8_blended($self->{_font}, $text, $self->{_color})
        or Carp::croak 'TTF rendering error: ' . SDL::get_error;

        $self->{surface} = $surface;
        my $arr = SDL::TTF::size_utf8( $self->{_font}, $text );
        $self->{w} = $arr->[0];
        $self->{h} = $arr->[1];
    }
    else {
        $self->{surface} = undef;
    }

    return $self;
}

sub surface {
    return $_[0]->{surface};
}

sub write_to {
    my ($self, $target, $text) = @_;

    $self->text($text) if defined $text;
    if ( my $surface = $self->{surface} ) {

        # Set source rect
        my $clip = $self->clip;
        $clip = SDL::Rect->new(0, 0, $surface->w, $surface->h) unless $clip;

        # Set target rect
        my $rect = $self->rect;
        $rect = SDL::Rect->new(0, 0, $target->w, $target->h) unless $rect;

        # Move text by horizontal align
        if ($self->{h_align} eq 'left' ) {
            $self->{x} = $rect->x;
        }
        elsif ($self->{h_align} eq 'center' ) {
            $self->{x} = $rect->x + ($rect->w / 2) - ($surface->w / 2);
        }
        elsif($self->{h_align} eq 'right' ) {
            $self->{x} = $rect->x + $rect->w - $surface->w;
        }

        # Move text by vertical align
        if ($self->{v_align} eq 'top' ) {
            $self->{y} = $rect->y;
        }
        elsif ($self->{v_align} eq 'middle' ) {
            $self->{y} = $rect->y + ($rect->h / 2) - ($surface->h / 2);
        }
        elsif($self->{v_align} eq 'bottom' ) {
            $self->{y} = $rect->y + $rect->h - $surface->h;
        }

        SDL::Video::blit_surface(
            $surface, SDL::Rect->new($clip->x,$clip->y,$clip->w, $clip->h),
            $target, SDL::Rect->new($self->{x}, $self->{y}, $surface->w, $surface->h)
        );
    }
    return;
}

sub write_xy {
    my ($self, $target, $x, $y, $text) = @_;

    $x = $self->x unless defined $x;
    $y = $self->y unless defined $y;

    $self->text($text) if defined $text;
    if ( my $surface = $self->{surface} ) {

        # Set source rect
        my $clip = $self->clip;
        $clip = SDL::Rect->new(0, 0, $surface->w, $surface->h) unless $clip;

        # Set target rect
        my $rect = $self->rect;
        $rect = SDL::Rect->new(0, 0, $target->w, $target->h) unless $rect;

        if ($self->{h_align} eq 'left' ) {
            $self->{x} = $rect->x + $x;
        }
        elsif ($self->{h_align} eq 'center' ) {
            $self->{x} = $rect->x + $x - ($surface->w / 2);
        }
        elsif($self->{h_align} eq 'right' ) {
            $self->{x} = $rect->x + $x - $surface->w;
        }

        if ($self->{v_align} eq 'top' ) {
            $self->{y} = $rect->y + $y;
        }
        elsif ($self->{v_align} eq 'middle' ) {
            $self->{y} = $rect->y + $y - ($surface->h / 2);
        }
        elsif($self->{v_align} eq 'bottom' ) {
            $self->{y} = $rect->y + $y - $surface->h;
        }

        SDL::Video::blit_surface(
                $surface, SDL::Rect->new($clip->x,$clip->y,$clip->w, $clip->h),
                $target, SDL::Rect->new($self->{x}, $self->{y}, $surface->w, $surface->h)
        );
    }
    return;
}

sub rect {
    my ( $self, $rect ) = @_;

    # short-circuit
    return $self->{rect} unless $rect;

    return $self->{rect} = SDLx::Validate::rect($rect);
}

sub clip {
    my ( $self, $clip ) = @_;

    # short-circuit
    return $self->{clip} unless $clip;

    return $self->{clip} = SDLx::Validate::rect($clip);
}

1;

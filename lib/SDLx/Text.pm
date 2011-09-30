package SDLx::Text;
use strict;
use warnings;
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

	my $color = defined $options{'color'} ? $options{'color'} : [255, 255, 255];

	my $size = $options{'size'} || 24;

	my $shadow        = $options{'shadow'}        || 0;
	my $shadow_offset = $options{'shadow_offset'} || 1;

	my $shadow_color  = defined $options{'shadow_color'}
	                  ? $options{'shadow_color'}
	                  : [0, 0, 0]
	                  ;

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
	$self->shadow($shadow);
	$self->shadow_color($shadow_color);
	$self->shadow_offset($shadow_offset);

    $self->bold($options{'bold'}) if exists $options{'bold'};
    $self->italic($options{'italic'}) if exists $options{'italic'};
    $self->underline($options{'underline'}) if exists $options{'underline'};
    $self->strikethrough($options{'strikethrough'}) if exists $options{'strikethrough'};

	$self->text( $options{'text'} ) if exists $options{'text'};

	return $self;
}

sub font {
	my ($self, $font_filename) = @_;

	if ($font_filename) {
		my $size = $self->size;

		$self->{_font} = SDL::TTF::open_font($font_filename, $size)
			or Carp::cluck "Error opening font '$font_filename': " . SDL::get_error;

	    $self->{_font_filename} = $font_filename;
	    $self->{_update_surfaces} = 1;
	}

	return $self->{_font};
}

sub font_filename {
    return $_[0]->{_font_filename};
}

sub color {
	my ($self, $color) = @_;

	if (defined $color) {
		$self->{_color} = SDLx::Validate::color($color);
	    $self->{_update_surfaces} = 1;
	}

	return $self->{_color};
}

sub size {
	my ($self, $size) = @_;

	if ($size) {
		$self->{_size} = $size;

		# reload the font using new size.
		# No need to set "_update_surfaces"
		# since font() already does it.
		$self->font( $self->font_filename );
	}

	return $self->{_size};
}

sub _style {
    my ($self, $flag, $enable) = @_;

    my $styles = SDL::TTF::get_font_style( $self->font );

    # do we have an enable flag?
    if (@_ > 2) {

        # we do! setup flags if we're enabling or disabling
        if ($enable) {
            $styles |= $flag;
        }
        else {
            $styles ^= $flag if $flag & $styles;
        }

        SDL::TTF::set_font_style( $self->font, $styles );

        # another run, returning true if value was properly set.
        return SDL::TTF::get_font_style( $self->font ) & $flag;
    }
    # no enable flag present, just return
    # whether the style is enabled/disabled
    else {
        return $styles & $flag;
    }
}

sub normal        { my $self = shift; $self->_style( TTF_STYLE_NORMAL,        @_ ) }
sub bold          { my $self = shift; $self->_style( TTF_STYLE_BOLD,          @_ ) }
sub italic        { my $self = shift; $self->_style( TTF_STYLE_ITALIC,        @_ ) }
sub underline     { my $self = shift; $self->_style( TTF_STYLE_UNDERLINE,     @_ ) }
sub strikethrough { my $self = shift; $self->_style( TTF_STYLE_STRIKETHROUGH, @_ ) }


sub h_align {
	my ($self, $align) = @_;

	if ($align) {
		$self->{h_align} = $align;
		$self->{_update_surfaces} = 1;
	}

	return $self->{h_align};
}

sub shadow {
	my ($self, $shadow) = @_;

	if ($shadow) {
	    $self->{shadow} = $shadow;
	    $self->{_update_surfaces} = 1;
	}

	return $self->{shadow};
}

sub shadow_color {
	my ($self, $shadow_color) = @_;

	if (defined $shadow_color) {
		$self->{shadow_color} = SDLx::Validate::color($shadow_color);
	    $self->{_update_surfaces} = 1;
	}

	return $self->{shadow_color};
}


sub shadow_offset {
	my ($self, $shadow_offset) = @_;

	if ($shadow_offset) {
	    $self->{shadow_offset} = $shadow_offset;
	    $self->{_update_surfaces} = 1;
	}

	return $self->{shadow_offset};
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

	if (defined $y) {
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

	    if ($self->{shadow}) {
	        my $shadow_surface = SDL::TTF::render_utf8_blended(
	              $self->{_font},
	              $text,
	              $self->{shadow_color}
	        ) or Carp::croak 'TTF shadow rendering error: ' . SDL::get_error;

	        $self->{_shadow_surface} = $shadow_surface;
	    }

        $self->{surface} = $surface;
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

	if (@_ > 2) {
	    $self->text($text);
	}
	elsif ($self->{_update_surfaces}) {
	    $self->{_update_surfaces} = 0;
	    $self->text( $self->text );
	}

	if ( my $surface = $self->{surface} ) {
		if ($self->{h_align} eq 'center' ) {
			$self->{x} = ($target->w / 2) - ($surface->w / 2);
		}
		elsif ($self->{h_align} eq 'right' ) {
			$self->{x} = $target->w - $surface->w;
		}

	   if ($self->{shadow}) {
	       my $shadow = $self->{_shadow_surface};
	       my $offset = $self->{shadow_offset};
	       SDL::Video::blit_surface(
	           $shadow, SDL::Rect->new(0,0,$shadow->w, $shadow->h),
	           $target, SDL::Rect->new($self->{x} + $offset, $self->{y} + $offset, 0, 0)
	       );
	   }

		SDL::Video::blit_surface(
			$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
			$target, SDL::Rect->new($self->{x}, $self->{y}, 0, 0)
		);
	}
	return;
}

sub write_xy {
	my ($self, $target, $x, $y, $text) = @_;

	if (@_ > 4) {
	    $self->text($text);
	}
	elsif ($self->{_update_surfaces}) {
	    $self->{_update_surfaces} = 0;
	    $self->text( $self->text );
	}

	if ( my $surface = $self->{surface} ) {
		if ($self->{h_align} eq 'center' ) {
			$x -= $surface->w / 2;
		}
		elsif ($self->{h_align} eq 'right' ) {
			$x -= $surface->w;
		}

	    if ($self->{shadow}) {
	        my $shadow = $self->{_shadow_surface};
	        my $offset = $self->{shadow_offset};
	        SDL::Video::blit_surface(
	            $shadow, SDL::Rect->new(0,0,$shadow->w, $shadow->h),
	            $target, SDL::Rect->new($x + $offset, $y + $offset, 0, 0)
	        );
	    }

		SDL::Video::blit_surface(
			$surface, SDL::Rect->new(0,0,$surface->w, $surface->h),
			$target, SDL::Rect->new($x, $y, 0, 0)
		);
	}
	return;
}

1;

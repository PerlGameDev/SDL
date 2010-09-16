package SDLx::TTF;
use strict;
use warnings;
use Carp;

use SDL;
use SDL::TTF;
use SDL::Font;


sub new
{
  my ($class, $font) = @_;

	my $self = {};

	unless ( SDL::Config->has('SDL_ttf') ) {
		Carp::cluck("SDL_ttf support has not been compiled");
	}
	unless ( SDL::TTF::was_init() )
	{
	   Carp::cluck ("Cannot init TTF: " . SDL::get_error() ) unless SDL::TTF::init() == 0;
	   $self->{inited} = 1;	
	   $self->{style} = {
		normal => TTF_STYLE_NORMAL,
		bold   => TTF_STYLE_BOLD,
		italic => TTF_STYLE_ITALIC,
		underline => TTF_STYLE_UNDERLINE,
		strikethrough => TTF_STYLE_STRIKETHROUGH
		};
	}

	my $ttf_font;
	unless ( $ttf_font = SDL::TTF::open_font($font, $size ))
	{
	
   	   Carp::cluck ("Cannot make a TTF font from location ($font) or size($size), due to: ". SDL::get_error );

	} 

	$self->{ttf_font} = $ttf_font;
	
	if (  $style && ( my $t_style = $self->{style}->{$style} )  )
	{
		 SDL::TTF::set_font_style($ttf_font, $t_style);
	}
	
	
  return bless $self, $class;
 
}


sub DESTROY {
	my $self = shift;
	SDL::TTF::quit if $self->{inited};

}

1;

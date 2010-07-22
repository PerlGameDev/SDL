package SDLx::SFont;
use strict;
use warnings;
use SDL::Image;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::TTF';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

use base 'Exporter';
our @EXPORT = ('SDL_TEXTWIDTH');

sub SDL_TEXTWIDTH {
	return SDLx::SFont::TextWidth( join( '', @_ ) );
}

sub print_text { #print is a horrible name for this
	my ( $surf, $x, $y, @text ) = @_;
	SDLx::SFont::print_string( $surf, $x, $y, join( '', @text ) );
}

bootstrap SDLx::SFont;

1;


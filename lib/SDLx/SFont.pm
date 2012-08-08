package SDLx::SFont;
use strict;
use warnings;
use SDL::Image;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::TTF';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

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


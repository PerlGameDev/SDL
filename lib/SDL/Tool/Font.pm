#
#	SDL::Tool::Font -	format agnostic font tool
#
#	Copyright (C) 2002 David J. Goehrig

package SDL::Tool::Font;

use strict;
use warnings;
use Carp;

use SDL;
use SDL::Font;
use SDL::TTFont;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %option = @_;

	verify (%option, qw/ -sfont -ttfont -size -fg -bg -foreground -background
			  	-normal -bold -italic -underline / ) if $SDL::DEBUG;

	if ($option{-sfont}) {
		$$self{-font} = new SDL::Font $option{-sfont};
	} elsif ($option{-ttfont} || $option{-t}) {
		$option{-size} ||= 12;
		$$self{-font} = new SDL::TTFont 
					-name => $option{-ttfont} || $option{-t},
					-size => $option{-size} || $option{-s},
					-fg => $option{-foreground} || $option{-fg} ,
					-bg => $option{-background} || $option{-bg};
		for (qw/ normal bold italic underline / ) {
			if ($option{"-$_"}) {
				&{"SDL::TTFont::$_"}($$self{-font});
			}
		}
	} else {
		croak "SDL::Tool::Font requires either a -sfont or -ttfont";	
	}
	bless $self,$class;
	$self;
}

sub DESTROY {

}

sub print {
	my ($self,$surface,$x,$y,@text) = @_;
	croak "Tool::Font::print requires a SDL::Surface\n"
		unless ($surface->isa('SDL::Surface'));
	if ($$self{-font}->isa('SDL::Font')) {
		$$self{-font}->use();
		SDL::SFont::PutString( $$surface, $x, $y, join('',@text));
	} else {
		$$self{-font}->print($surface,$x,$y,@text);
	}
}

1;

__END__;

=pod

=head1 NAME

SDL::Tool::Font - a perl extension

=head1 DESCRIPTION

L<SDL::Tool::Font> provides a unified interface for applying
True Type and SFont fonts to various surfaces.

=head1 METHODS

=head2 print ( surface, x, y, text ... )

C<SDL::Tool::Font::print> print the given text on the supplied surface
with the upper left hand corner starting at the specified coordinates.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Font> L<SDL::TTFont> L<SDL::Surface>

=cut

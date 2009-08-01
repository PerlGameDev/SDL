# SDL::OpenGL.pm
#
#	SFont bitmat font support
#
#	Copyright (C) 2004 David J. Goehrig

package SDL::SFont;

require Exporter;
require DynaLoader;
use vars qw(
	@EXPORT
	@ISA
);
@ISA=qw(Exporter DynaLoader);

use SDL;

BEGIN {

};

sub SDL_TEXTWIDTH {
	return SDL::SFont::TextWidth(join('',@_));
}


bootstrap SDL::SFont;

1;

__END__;

=pod



=head1 NAME

SDL::SFont - a perl extension

=head1 DESCRIPTION



=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::App>

=cut

#	Font.pm
#
#	a SDL perl extension for SFont support
#
#	Copyright (C) David J. Goehrig 2000,2002
#

package SDL::Font;
use strict;
use SDL;
use SDL::SFont;
use SDL::Surface;

use vars qw(@ISA $CurrentFont );
	    

@ISA = qw(SDL::Surface);


sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = \SDL::SFont::NewFont(shift);
	bless $self,$class;
	return $self;	
}

sub DESTROY {
	my $self = shift;
	SDL::FreeSurface($$self);
}

sub use ($) {
	my $self = shift;
	$CurrentFont = $self;
	if ( $self->isa('SDL::Font')) {
		SDL::SFont::UseFont($$self);
	}	
}

1;

__END__;

=pod


=head1 NAME

SDL::Font - a SDL perl extension

=head1 SYNOPSIS

  $font = new Font "Font.png";
  $font->use();
	
=head1 DESCRIPTION

L<SDL::Font> provides an interface to loading and using SFont style 
fonts with L<SDL::Surface> objects.  

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Surface>

=cut

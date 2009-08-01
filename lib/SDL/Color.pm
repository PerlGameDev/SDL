#	Color.pm
#
#	A package for manipulating SDL_Color *
#
#	Copyright (C) 2002,2003,2004 David J. Goehrig

package SDL::Color;

use strict;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self;

	my (%options) = @_;

	verify (%options, qw/ -color -surface -pixel -r -g -b /) if $SDL::DEBUG;

	if ($options{-color}) {
		$self = \$options{-color};	
	} elsif ($options{-pixel} && $options{-surface}) {
		die "SDL::Color::new requires an SDL::Surface"
			unless !$SDL::DEBUG || $options{-surface}->isa("SDL::Surface");
		$self = \SDL::NewColor(SDL::GetRGB(${$options{-surface}}, $options{-pixel}));
	} else {
		my @color;
		push @color, $options{-red}	|| $options{-r} || 0;
		push @color, $options{-green}	|| $options{-g} || 0;
		push @color, $options{-blue}	|| $options{-b} || 0;
		$self = \SDL::NewColor(@color);
	} 
	die "Could not create color, ", SDL::GetError(), "\n"
		unless ($$self);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	SDL::FreeColor(${$_[0]});
}

sub r {
	my $self = shift;
	SDL::ColorR($$self,@_);	
}

sub g {
	my $self = shift;
	SDL::ColorG($$self,@_);
}

sub b {
	my $self = shift;
	SDL::ColorB($$self,@_);
}

sub pixel {
	die "SDL::Color::pixel requires an SDL::Surface"
		unless !$SDL::DEBUG || $_[1]->isa("SDL::Surface");
	SDL::MapRGB(${$_[1]},$_[0]->r(),$_[0]->g(),$_[0]->b());
}

$SDL::Color::black = new SDL::Color -r => 0, -g => 0, -b => 0;
$SDL::Color::white = new SDL::Color -r => 255, -g => 255, -b => 255;
$SDL::Color::red = new SDL::Color -r => 255, -g => 0, -b => 0;
$SDL::Color::blue = new SDL::Color -r => 0, -g => 0, -b => 255;
$SDL::Color::green = new SDL::Color -r => 0, -g => 255, -b => 0;
$SDL::Color::purple = new SDL::Color -r => 255, -g => 0, -b => 255;
$SDL::Color::yellow = new SDL::Color -r => 255, -g => 255, -b => 0;

1;

__END__;

=pod

=head1 NAME

SDL::Color - a SDL perl extension

=head1 SYNOPSIS

  $color = new SDL::Color ( -r => 0xde, -g => 0xad, -b =>c0 );
  $color = new SDL::Color -surface => $app, -pixel => $app->pixel($x,$y);
  $color = new SDL::Color -color => SDL::NewColor(0xff,0xaa,0xdd);

=head1 DESCRIPTION

C<SDL::Color> is a wrapper for display format independent color
representations, with the same interface as L<SDL::Color>.  

=head2 new ( -color => )

C<SDL::Color::new> with a C<-color> option will construct a new object
referencing the passed SDL_Color*.

=head2 new (-r => , -g => , -b => )

C<SDL::Color::new> with C<-r,-g,-b> options will construct both a SDL_Color
structure, and the associated object with the specified vales.

=head2 new (-pixel =>, -surface =>)

C<SDL::Color::new> with C<-pixel,-surface> options will generate a SDL_Color*
with the r,g,b values associated with the integer value passed by C<-pixel>
for the given C<-surface>'s format.

=head2 r ( [ red ] ), g( [ green ] ), b( [ blue ] )

C<SDL::Color::r, SDL::Color::g, SDL::Color::b> are accessor methods for
the red, green, and blue components respectively.  The color value can be set
by passing a byte value (0-255) to each function.

=head2 pixel ( surface )

C<SDL::Color::pixel> takes a C<SDL::Surface> object and r,g,b values, and
returns the integer representation of the closest color for the given surface.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Surface> 

=cut

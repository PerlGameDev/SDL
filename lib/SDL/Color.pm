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

	# called like SDL::Color->new($red,$green,$blue);
	return bless \SDL::NewColor(@_), $class if (@_ == 3);

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
	bless $self, $class;
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

sub rgb {
	my $self = shift;
	SDL::ColorRGB($$self,@_);
}

sub pixel {
	die "SDL::Color::pixel requires an SDL::Surface"
		unless !$SDL::DEBUG || $_[1]->isa("SDL::Surface");
	SDL::MapRGB(${$_[1]},$_[0]->r(),$_[0]->g(),$_[0]->b());
}

$SDL::Color::black = SDL::Color->new(0,0,0);
$SDL::Color::white = SDL::Color->new(255,255,255);
$SDL::Color::red = SDL::Color->new(255,0,0);
$SDL::Color::blue = SDL::Color->new(0,0,255);
$SDL::Color::green = SDL::Color->new(0,255,0);
$SDL::Color::purple = SDL::Color->new(255,0,255);
$SDL::Color::yellow = SDL::Color->new(255,255,0);

1;

__END__;

=pod

=head1 NAME

SDL::Color - a SDL perl extension

=head1 SYNOPSIS

  $color = SDL::Color->new($red,$green,$blue);		# fastest

  $color = new SDL::Color ( -r => 0xde, -g => 0xad, -b =>c0 );
  $color = new SDL::Color -surface => $app, -pixel => $app->pixel($x,$y);
  $color = new SDL::Color -color => SDL::NewColor(0xff,0xaa,0xdd);

=head1 DESCRIPTION

C<SDL::Color> is a wrapper for display format independent color
representations.

=head2 new ( -color => )

C<SDL::Color::new> with a C<-color> option will construct a new object
referencing the passed SDL_Color*.

=head2 new ($r, $g, $b)

C<SDL::Color::new> with three color values will construct both a SDL_Color
structure, and the associated object with the specified values.

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

=head2 rgb ( $red, $green, $blue )

C<SDL::Color::rgb> is an accessor method for the red, green, and blue components
in one go. It will return a list of three values.

The color value can be set by passing a byte value (0-255) for each color component.

=head2 pixel ( surface )

C<SDL::Color::pixel> takes a C<SDL::Surface> object and r,g,b values, and
returns the integer representation of the closest color for the given surface.

=head1 AUTHOR

David J. Goehrig

Additions by Tels 2006.

=head1 SEE ALSO

L<perl> and L<SDL::Surface>.

=cut

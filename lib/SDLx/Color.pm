package SDLx::Color;
use strict;
use warnings;
no warnings "uninitialized"; #undef is 0 in this module
use SDL ();
use SDL::Video ();
use SDL::Color ();
use Carp ();
use Scalar::Util ();

# TODO: MAP_RGB(A). AND TEST! #

sub new_rgb {
	my ($class, @arg) = @_;
	$class = ref $class || $class;
	if(@arg == 1 and !defined($arg[0]) || Scalar::Util::looks_like_number($arg[0])) {
		my $num = $arg[0];
		Carp::carp("Number given as color was bigger than maximum expected: 0xFFFFFF")
			if $num > 0xFFFFFF;
		Carp::carp("Number given as color was negative")
			if $num < 0;
		return bless {
			r => $arg[0] >> 16 & 255,
			g => $arg[0] >> 8  & 255,
			b => $arg[0]       & 255,
			a => 0
		}, $class;
	}
	$class->new(@arg);
}

sub new_rgba {
	my ($class, @arg) = @_;
	$class = ref $class || $class;
	if(@arg == 1 and !defined($arg[0]) || Scalar::Util::looks_like_number($arg[0])) {
		my $num = $arg[0];
		Carp::carp("Number given as color was bigger than maximum expected: 0xFFFFFFFF")
			if $num > 0xFFFFFFFF;
		if($num < 0) {
			Carp::carp("Number given as color was negative");
			$num = 0;
		}
		return bless {
			r => $num >> 24 & 0xFF,
			g => $num >> 16 & 0xFF,
			b => $num >> 8  & 0xFF,
			a => $num       & 0xFF
		}, $class;
	}
	$class->new(@arg);
}

sub new {
	my ($class, @arg) = @_;
	$class = ref $class || $class;
	if(@arg > 1) {
		@arg = ( \@arg ); #to be processed as arrayref
	}
	if(@arg == 1) {
		my $arg = $arg[0];
		if(!$arg) {
			return $class->new_rgb($arg); #could have been new_rgba as well
		}
		elsif(Scalar::Util::looks_like_number($arg)) {
			Carp::croak("new does not know what to do with numbers. Use new_rgb or new_rgba");
		}
		elsif(Scalar::Util::blessed($arg) and $arg->isa("SDLx::Color")) {
			return $arg;
		}
		elsif(Scalar::Util::blessed($arg) and $arg->isa("SDL::Color")) {
			return bless {
				r => $arg->r,
				g => $arg->g,
				b => $arg->b,
				a => 0
			}, $class;
		}
		elsif(ref $arg eq "ARRAY" or ref $arg eq "HASH") {
			my @arg;
			if(ref $arg eq "HASH") {
				@arg = (
					$arg->{r},
					$arg->{g},
					$arg->{b},
					$arg->{a}
				);
			}
			else {
				@arg = @$arg[0..3];
			}
			for(@arg) {
				Carp::croak("All values in an array/hash must be numbers")
					if Scalar::Util::looks_like_number($_);
				Carp::carp("Number bigger than maximum expected: 0xFF")
					if $_ > 0xFF;
				if($_ < 0) {
					Carp::carp("Number was negative");
					$_ = 0;
				}
				$_ ||= 0;
			}
			return bless {
				r => $arg[0],
				g => $arg[1],
				b => $arg[2],
				a => $arg[3]
			}, $class;
		}
		else {
			Carp::croak("Color given is of a type not understood");
		}
	}
	else {
		Carp::croak("Must recieve an argument, even if it's undef")
	}
}

sub r { $_[0]->{r} }
sub g { $_[0]->{g} }
sub b { $_[0]->{b} }
sub a { $_[0]->{a} }

sub rgb {
	my ($self) = @_;
	0 + (sprintf "0x" . "%02x" x 3, $self->r, $self->g, $self->b);
}
sub rgba {
	my ($self) = @_;
	0 + ($self->rgb . sprintf "%02x", $self->a);
}
sub map_rgb {
	my ($self) = @_;
	
}
sub map_rgba {
	my ($self) = @_;
	
}
sub color {
	my ($self) = @_;
	SDL::Color->new(
		$self->r,
		$self->g,
		$self->b
	);
}

1;

package SDLx::Color;
use strict;
use warnings;
no warnings "uninitialized"; #undef is 0 in this module
use SDL::Color ();
use SDL::Video ();
use SDLx::Surface ();
use Carp ();
use Scalar::Util ();

sub _make_t {
	my ($t, $arg) = @_;
	Carp::croak("Wrong amount of arguments")
		unless @_ == 2;
	my ($num_rgb, $num_rgba, $list_rgb, $list_rgba, $error);
	$t == 0 ? $num_rgb   = 1 :
	$t == 1 ? $num_rgba  = 1 :
	$t == 3 ? $list_rgb  = 1 :
	$t == 4 ? $list_rgba = 1 :
			  $error     = 1 ;
	Carp::croak("$t invalid. You shouldn't be calling this directly anyway")
		if $error;
	$t += 3 if $t < 3; #$t is 3 if rgb and 4 if rgba
	my $list = $list_rgb || $list_rgba; 
	if(!$arg) {
		return(
			$list ? (0) x $t :
			        0
		);
	}
	elsif(Scalar::Util::looks_like_number($arg)) {
		if($arg < 0) {
			Carp::carp("Color was a negative number");
			return(
				$list ? (0) x $t :
				        0
			);
		}
		elsif($arg > 0xFFFFFF) {
			Carp::carp("Color was number greater than maximum expected: 0x" . "FF" x $t);
			return(
				$num_rgb  ? 0xFFFFFF   :
				$num_rgba ? 0xFFFFFFFF :
				            (0xFF) x $t
			);
		}
		if($list_rgb) {
			return(
				$arg >> 16 & 0xFF,
				$arg >>  8 & 0xFF,
				$arg       & 0xFF
			);
		}
		elsif($list_rgba) {
			return(
				$arg >> 24,
				$arg >> 16 & 0xFF,
				$arg >>  8 & 0xFF,
				$arg       & 0xFF
			);
		}
		else {
			return $arg;
		}
	}
	elsif(Scalar::Util::blessed($arg) and $arg->isa("SDLx::Color")) {
		if($num_rgb) {
			return(
				($arg->r << 16) +
				($arg->g <<  8) +
				($arg->b      )
			);
		}
		elsif($num_rgba) {
			return(
				($arg->r << 24) +
				($arg->g << 16) +
				($arg->b <<  8) +
				(0xFF         )
			)
		}
		elsif($list_rgb) {
			return(
				$arg->r,
				$arg->g,
				$arg->b
			);
		}
		else {
			return(
				$arg->r,
				$arg->g,
				$arg->b,
				0xFF
			);
		}
	}
	elsif(ref $arg eq "ARRAY") {
		if(@$arg > $t) {
			Carp::carp("Color arrayref had more values than maximum expected: $t");
			@$arg = @$arg[0..$t-1];
		}
		for(@$arg) {
			$_ ||= 0;
			Carp::croak("All values in color arrayref must be numbers")
				unless Scalar::Util::looks_like_number($_);
			if($_ > 0xFF) {
				Carp::carp("Number in color arrayref was greater than maximum expected: 0xFF");
				$_ = 0xFF;
			}
			elsif($_ < 0) {
				Carp::carp("Number in color arrayref was negative");
				$_ = 0;
			}
		}
		if($num_rgb) {
			return(
				($arg->[0] << 16) +
				($arg->[1] <<  8) +
				($arg->[2]      )
			);
		}
		elsif($num_rgba) {
			return(
				($arg->[0] << 24) +
				($arg->[1] << 16) +
				($arg->[2] <<  8) +
				($arg->[3]      )
			);
		}
		else {
			return @$arg[0..$t-1];
		}
	}
	else {
		Carp::croak("Color must be a number, an arrayref, or an SDLx::Color");
	}
}

sub num_rgb {
	return(
		_make_t( 0, @_ )
	);
}
sub num_rgba {
	return(
		_make_t( 1, @_ )
	);
}

sub list_rgb {
	return(
		_make_t( 3, @_ )
	);
}
sub list_rgba {
	return(
		_make_t( 4, @_ )
	);
}

sub color {
	return SDL::Color->new(
		_make_t( 3, @_ )
	);
}

sub map_rgb {
	return SDL::Video::map_rgb(
		SDLx::Surface::display->format,
		_make_t( 3, @_ )
	);
}
sub map_rgba {
	return SDL::Video::map_rgba(
		SDLx::Surface::display->format,
		_make_t( 4, @_ )
	);
}

1;

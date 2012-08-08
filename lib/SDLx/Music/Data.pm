package SDLx::Music::Data;

use strict;
use warnings;
use vars qw($VERSION);

our $VERSION = '2.541_09';
$VERSION = eval $VERSION;

sub volume {
	$_[0]->{volume} = $_[1] if $_[1];
	return $_[0];
}

sub file {
	if ( $_[1] ) {
		$_[0]->{file}    = $_[1];
		$_[0]->{to_load} = 1;
	}
	return $_[0];
}


sub fade_in {
	$_[0]->{fade_in} = $_[1] if $_[1];
	return $_[0];
}

sub loops {
	$_[0]->{loops} = $_[1] if $_[1];
	return $_[0];
}

1;

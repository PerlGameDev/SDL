package SDLx::Music::Default;
use strict;
use warnings;

sub ext  
{

	$_[0]->{ext} = $_[1] if $_[1];
	return $_[0]->{ext};
}

sub dir
{
	$_[0]->{dir} = $_[1] if $_[1];
	return $_[0]->{dir};
}

1;

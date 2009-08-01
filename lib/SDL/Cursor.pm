# Cursor.pm
#
#	Copyright (C) 2000,2002 David J. Goehrig
#

package SDL::Cursor;
use strict;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -data -mask -x -y /) if $SDL::DEBUG;

	my $self = \SDL::NewCursor($options{-data},$options{-mask},
				$options{-x},$options{-y});
	bless $self, $class;
	$self;
}

sub DESTROY ($) {
	my $self = shift;
	SDL::FreeCursor($$self);
}

sub warp ($$$) {
	my ($self,$x,$y) = @_;
	SDL::WarpMouse($x,$y);
}

sub use ($) {
	my $self = shift;
	SDL::SetCursor($$self);
}

sub get () {
	SDL::GetCursor();
}

sub show ($;$) {
	my ($self,$toggle) = @_;
	SDL::ShowCursor($toggle);
}

1;

__END__;

=pod



=head1 NAME

SDL::Cursor - a SDL perl extension

=head1 SYNOPSIS

  $cursor = SDL::Cursor->new(
	-data => new SDL::Surface "cursor.png",
	-mask => new SDL::Surface "mask.png",
	-x    => 0, -y => 0 );
  $cusor->use;

=head1 DESCRIPTION

the SDL::Cursor module handles mouse cursors, and provide the developer to
use custom made cursors. Note that the cursors can only be in black and
white.

=head1 METHODS

=head2 new( -data => $surface_data, -mask => $surface_mask, x => $x, y => $y)

Creates a new cursor. The <C>-data</C> and <C>-mask</C> parameters should be both black and white pictures. The height and width of these surfaces should be a multiple of 8. The <C>-x</C> and <C>-y</C> are the coordinates of the cursor 'hot spot'.

=head2 warp($x, $y)

Set the position of the cursor at the <C>$x</C>, <C>$y</C> coordinates in the application window.

=head2 use()

Set the cursor as the active cursor.

=head2 get()

When used statically <C>SDL::Cursor::get()</C>, it will return the instance of the current cursor in use. Called as a method, it will return itself.

This method can be useful if you are dealing with several cursors.

=head2 show($toggle)

Set the visibility of the cursor. A false value will make the cursor
invisible in the Application window. A true value will show it back.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Surface>

=cut	

package SDLx::FPS;
use strict;
use warnings;
use vars qw($VERSION @ISA);
use SDL::GFX::Framerate;
use SDL::GFX::FPSManager;
use Carp;
our @ISA = qw(SDL::GFX::FPSManager);

our $VERSION = '2.541_09';
$VERSION = eval $VERSION;

sub new {
	my ( $class, %args ) = @_;

	for ( grep { $_ ne 'fps' } keys %args ) {
		Carp::cluck("Unrecognized constructor hash key: $_");
	}
	my $fps = $class->SDL::GFX::FPSManager::new( 0, 0, 0, 0 );
	SDL::GFX::Framerate::init($fps);
	$fps->set( $args{fps} ) if defined $args{fps};
	$fps;
}

sub set {
	SDL::GFX::Framerate::set( @_[ 0, 1 ] );
}

sub get {
	SDL::GFX::Framerate::get( $_[0] );
}

sub delay {
	SDL::GFX::Framerate::delay( $_[0] );
}

1;

__END__

=head1 NAME

SDLx::FPS - a more convenient way to set a framerate

=head1 SYNOPSIS

 use SDLx::FPS;
 my $fps = SDLx::FPS->new(fps => 60);
 while(1) { # Main game loop
     # Do game related stuff

     $fps->delay;
 }

=head1 DESCRIPTION

SDLx::FPS simplifies the task of giving your game a framerate.
Basically, it combines the methods of C<SDL::GFX::Framerate> and C<SDL::GFX::FPSManager> into a single module.
Use it to delay the main loop to keep it at a specified framerate.

=head1 METHODS

=head2 new

 my $fps = SDLx::FPS->new( fps => 30 );

No arguments are required, if no C<fps> is specified, the default FPS is 30.

=head2 set

 $fps->set($new_framerate);

Same as C<SDL::GFX::Framerate::set>.
Set the new desired framerate.

=head2 get

Same as C<SDL::GFX::Framerate::get>.
Get the currently set framerate.

=head2 delay

Same as C<SDL::GFX::Framerate::delay>.
Generate a delay to accommodate currently set framerate.
Call once in the graphics/rendering loop.
If the computer cannot keep up with the rate (i.e. drawing too slow), the delay is 0 and the delay interpolation is reset.

=head2 framecount

Return the C<framecount>.

=head2 rateticks

Return the C<rateticks>.

=head2 lastticks

Return the C<lastticks>.

=head2 rate

Return the C<rate>.

=head1 AUTHORS

See L<SDL/AUTHORS>.

=head1 SEE ALSO

L<< SDL::GFX::Framerate >>, L<< SDL::GFX::FPSManager >>

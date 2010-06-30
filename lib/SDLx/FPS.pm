package SDLx::FPS;
use strict;
use SDL::GFX::Framerate;
use SDL::GFX::FPSManager;
use Carp;
our @ISA = qw(SDL::GFX::FPSManager);

sub new {
	my ($class, %options) = @_;
	my $fps = bless(
		SDL::GFX::FPSManager->new(map defined() ? $_ : 0, @options{qw/framecount rateticks lastticks rate/}),
		ref $class || $class
	);
	$fps->init;
	$fps->set($options{fps}) if defined $options{fps};
	for(grep {
		my $key = $_;
		!grep $_ eq $key, qw/fps framecount rateticks lastticks rate/;
	} keys %options) {
		Carp::carp("Unrecognized constructor hash key: $_");
	}
	$fps;
}
sub init {
	SDL::GFX::Framerate::init($_[0]);
}
sub set {
	SDL::GFX::Framerate::set(@_[0, 1]);
}
sub get {
	SDL::GFX::Framerate::get($_[0]);
}
sub delay {
	SDL::GFX::Framerate::delay($_[0]);
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

 my $fps = SDLx::FPS->new(fps => 60, framecount => 0, rateticks => 0, lastticks => 0, rate => 0);

The constructor takes a hash with 5 possible arguments as shown.
No arguments are required, if no C<fps> is specified, the default FPS is 30.

C<framecount>, C<rateticks>, C<lastticks> and C<rate> correspond to the 4 arguments given to C<SDL::GFX::FPSManager->new()>.

=head2 init

 $fps->init;

Same as C<SDL::GFX::Framerate::init>.
Initialize the framerate manager, set default framerate of 30Hz and reset delay interpolation.
You don't need to call this; C<new> does it for you.

=head2 set

 $fps->set($new_framerate);

Same as C<SDL::GFX::Framerate::set>.
Set the new desired framerate.

=head2 get

 my $rate = $fps->get;

Same as C<SDL::GFX::Framerate::get>.
Get the currently set framerate.

=head2 delay

 $fps->delay;

Same as C<SDL::GFX::Framerate::delay>.
Generate a delay to accommodate currently set framerate.
Call once in the graphics/rendering loop.
If the computer cannot keep up with the rate (i.e. drawing too slow), the delay is 0 and the delay interpolation is reset.

=head2 framecount

 my $fc = $fps->framecount;

Return the C<framecount>.

=head2 rateticks

 my $rt = $fps->rateticks;

Return the C<rateticks>.

=head2 lastticks

 my $lt = $fps->lastticks;

Return the C<lastticks>.

=head2 rate

 my $r = $fps->rate;

Return the C<rate>.

=head1 AUTHORS

Blaise Roth, C<< <blaiseroth@gmail.com> >>

=head1 SEE ALSO

L<< SDL::GFX::Framerate >>, L<< SDL::GFX::FPSManager >>

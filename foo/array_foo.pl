use strict;
use warnings;

use SDL;
use SDL::Rect;
use SDLx::Surface;
use SDL::Video;
use Benchmark qw(:all);

SDL::init(SDL_INIT_VIDEO);
my $app = SDLx::Surface::get_display( width => 200, height => 200 );

my $foo = SDLx::Surface->new( width => 200, height => 200 );
my $foo_ = SDLx::Surface->new( width => 200, height => 200 );

my $foo_surf = $foo->surface;
my $foo__surf = $foo_->surface;

my @update_rects = ( );

sub a 
{
	return int(rand(100)+50);
}

foreach( 0..200000)
{
	push ( @update_rects, SDL::Rect->new(a,a,a,a ) );
}

sub update_rects_test
{

   SDL::Video::update_rects( $foo_surf, @update_rects );

}


sub update_rects_test_two
{

   SDL::Video::update_rects_fast( $foo__surf, \@update_rects );

}


cmpthese( -1, { one=> 'update_rects_test', two => 'update_rects_test_two' } );




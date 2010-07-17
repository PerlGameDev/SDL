use strict;
use warnings;

use SDL;
use SDL::Rect;
use SDLx::Surface;
use SDL::Video;
use Test::More;
use Benchmark qw(:all);

my $foo = SDLx::Surface::get_display( width => 200, height => 200 );


my @update_rects = ( );

foreach( 0...20)
{
	push ( @update_rects, SDL::Rect->new(rand(200), rand(200),rand(200),rand(200)) );
}

sub update_rects_test
{

   SDL::Video::update_rects( $foo->surface, \@update_rects );

}


sub update_rects_test_two
{

   SDL::Video::update_rects_fast( $foo->surface, \@update_rects );

}


cmpthese( -1, { one=> 'update_rects_test', two => 'update_rects_test_two' } );

pass();

done_testing();

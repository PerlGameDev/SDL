#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use SDL::Version;
use SDL::Net;
use Test::More;

=pod
use lib 't/lib';
use SDL::TestTool;


=cut

if ( !SDL::Config->has('SDL_net') ) {
    plan( skip_all => 'SDL_net support not compiled' );
} 

my @done =qw/ 
	init
	quit
	  /;

can_ok ('SDL::Net', @done); 
 
my $v       = SDL::Net::linked_version();
isa_ok($v, 'SDL::Version', '[linked_version]');
diag sprintf("got version: %d.%d.%d", $v->major, $v->minor, $v->patch);

is( 0, SDL::Net::init(), '[init] SDL net is inited');
SDL::Net::quit();
pass ('[quit] SDL net quit');
my @left = qw/
	read16
	write16
	read32
	write32	
	/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';

done_testing();

SDL::delay(100);

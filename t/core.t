#!/usr/bin/perl -w
use strict;
use Config;

use SDL;
use SDL::Video;
use SDL::Version;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
} else {
    plan( tests => 12 );
}

my @done =qw/ 
init
quit
was_init
get_error
version
linked_version
putenv
getenv
init_sub_system
quit_sub_system
/;

use_ok( 'SDL' ); 
can_ok ('SDL', @done); 

my $v = SDL::linked_version();
isa_ok($v, 'SDL::Version', '[linked_version]');
diag sprintf("got version: %d.%d.%d", $v->major, $v->minor, $v->patch);

my $display =  SDL::Video::set_video_mode(640,480,232, SDL_SWSURFACE );

isnt( SDL::get_error(), '', '[get_error] got error '.SDL::get_error() );

SDL::quit_sub_system(SDL_INIT_VIDEO);
isnt( SDL::was_init( SDL_INIT_VIDEO ), SDL_INIT_VIDEO, '[was_init] recognizes turned off sub system');
SDL::init_sub_system(SDL_INIT_VIDEO);
is( SDL::was_init( SDL_INIT_VIDEO ), SDL_INIT_VIDEO, '[was_init] recognizes turned back on sub system');

SDL::quit(); pass '[quit] SDL quit with out segfaults or errors';

isnt( SDL::was_init( 0 ), SDL_INIT_VIDEO, '[was_init] recognizes turned off flags');

SKIP:
{
	skip 'perl compiled with -DPERL_USE_SAFE_PUTENV', 2 if defined $Config{'config_args'} && $Config{'config_args'} =~ /PERL_USE_SAFE_PUTENV/;
	is(SDL::putenv('PERLSDL_TEST=hello'), 0, '[putenv] returns 0');
	is(SDL::getenv('PERLSDL_TEST'), 'hello', '[getenv] returns hello');
}

my @left = qw/
load_object
load_function
unload_function
unload_object
/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 

pass 'Are we still alive? Checking for segfaults';
sleep(2);

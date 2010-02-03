#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
}
elsif( !SDL::Config->has('SDL_mixer') )
{
    plan( skip_all => 'SDL_mixer support not compiled' );
}
my @done = qw//;

my @left = qw/
registereffect	  	
unregistereffect	  	
unregisteralleffects	  	
setpostmix	  	
setpanning	  	
setdistance	  	
setposition	  	
setreversestereo	  
/	
;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented SDL::Mixer::Effects::$_" foreach(@left)
    
}
diag $why;

done_testing();


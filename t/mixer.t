#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my @done = qw//;

my @left = qw/
linked_version	  	
init	  	
quit	  	
openaudio	  	
closeaudio	  	
seterror	  	
geterror	  	
queryspec	  	
getnumchunkdecoders	  	
getchunkdecoder	  	
loadwav	  	
loadwav_rw	  	
quickload_wav	  	
quickload_raw	  	
volumechunk	  	
freechunk	  	
allocatechannels	  	
volume	  	
playchannel	  	
playchanneltimed	  	
fadeinchannel	  	
fadeinchanneltimed	  	
pause	  	
resume	  	
haltchannel	  	
expirechannel	  	
fadeoutchannel	  	
channelfinished	  	
playing	  	
paused	  	
fadingchannel	  	
getchunk	  	
reservechannels	  	
groupchannel	  	
groupchannels	  	
groupcount	  	
groupavailable	  	
groupoldest	  	
groupnewer	  	
fadeoutgroup	  	
haltgroup	  	
getnummusicdecoders	  	
getmusicdecoder	  	
loadmus	  	
freemusic	  	
playmusic	  	
fadeinmusic	  	
fadeinmusicpos	  	
hookmusic	  	
volumemusic	  	
pausemusic	  	
resumemusic	  	
rewindmusic	  	
setmusicposition	  	
setmusiccmd	  	
haltmusic	  	
fadeoutmusic	  	
hookmusicfinished	  	
getmusictype	  	
playingmusic	  	
pausedmusic	  	
fadingmusic	  	
getmusichookdata	  	
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
    fail "Not Implmented SDL::Mixer::*::$_" foreach(@left)
    
}
diag $why;

done_testing();

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
else
{
    plan( tests => 2 );
}

use_ok( 'SDL::Mixer' ); 
  
can_ok ('SDL::Mixer', qw/
	query_spec
	reserve_channels
	allocate_channels
	group_channel
	group_channels
	group_available
	group_count
	group_oldest
	group_newer
	play_channel
	play_music
	fade_in_channel
	fade_in_music
	volume
	volume_music
	halt_channel
	halt_group
	halt_music
	expire_channel
	fade_out_channel
	fade_out_group
	fade_out_music
	fading_music
	fading_channel
	pause
	resume
	paused
	pause_music
	resume_music
	rewind_music
	paused_music
	playing
	playing_music
	/);

sleep(2);

#!/usr/bin/perl -w
use strict;
use SDL;

BEGIN {
    use Test::More;
    use lib 't/lib';
    use SDL::TestTool;

    plan( skip_all => 'Failed to init cdrom' )
      unless SDL::TestTool->init(SDL_INIT_CDROM);
}

use SDL::CD;
use SDL::CDROM;
use SDL::CDTrack;

is( CD_ERROR,       -1, 'CD_ERROR should be imported' );
is( CD_ERROR(),     -1, 'CD_ERROR() should also be available' );
is( CD_PAUSED,      3,  'CD_PAUSED should be imported' );
is( CD_PAUSED(),    3,  'CD_PAUSED() should also be available' );
is( CD_PLAYING,     2,  'CD_PLAYING should be imported' );
is( CD_PLAYING(),   2,  'CD_PLAYING() should also be available' );
is( CD_STOPPED,     1,  'CD_STOPPED should be imported' );
is( CD_STOPPED(),   1,  'CD_STOPPED() should also be available' );
is( CD_TRAYEMPTY,   0,  'CD_TRAYEMPTY should be imported' );
is( CD_TRAYEMPTY(), 0,  'CD_TRAYEMPTY() should also be available' );

is( SDL_AUDIO_TRACK,   0, 'SDL_AUDIO_TRACK should be imported' );
is( SDL_AUDIO_TRACK(), 0, 'SDL_AUDIO_TRACK() should also be available' );
is( SDL_DATA_TRACK,    4, 'SDL_DATA_TRACK should be imported' );
is( SDL_DATA_TRACK(),  4, 'SDL_DATA_TRACK() should also be available' );

my $num_drives = SDL::CDROM::num_drives();
ok( $num_drives >= 0, "[SDL::CDROM::num_drives] is $num_drives" );

SKIP:
{
    skip( "no drives available or SDL_RELEASE_TESTING not set", 17 )
      if $num_drives <= 0 || !$ENV{SDL_RELEASE_TESTING};
    for ( 0 .. $num_drives - 1 ) {
        my $name = SDL::CDROM::name($_);
        ok( $name, "[SDL::CDROM::name] for drive $_ is $name" );
    }
    my $cd = SDL::CD->new(0);
    isa_ok( $cd, 'SDL::CD', "[SDL::CD->new]" );
    my $status = $cd->status();
    my %states = (
        -1 => 'CD_ERROR',
        0  => 'CD_TRAYEMPTY',
        1  => 'CD_STOPPED',
        2  => 'CD_PLAYING',
        3  => 'CD_PAUSED'
    );
    my %types = (
        0 => 'SDL_AUDIO_TRACK',
        1 => 'SDL_DATA_TRACK'
    );
    ok(
        defined $states{$status},
        "[SDL::CD->status] is "
          . ( defined $states{$status} ? $states{$status} : 'undefined' )
    );
  SKIP:
    {
        skip( "CD should be in CD_STOPPED state", 14 )
          unless $status == CD_STOPPED;
        my $track = $cd->track(3);
        isa_ok( $track, 'SDL::CDTrack', "[SDL::CD->track]" );
        my $id = $cd->id();
        ok( $id >= 0, "[SDL::CD->id] is $id" );
        my $num_tracks = $cd->num_tracks();
        ok( $num_tracks >= 0, "[SDL::CD->num_tracks] is $num_tracks" );

        is( $cd->play_tracks( 4, 0, 5, 0 ),
            0, "[SDL::CD->play_tracks] playing track 4" );
        SDL::delay(2000);
        is( $cd->pause(), 0, "[SDL::CD->pause] succeeded" );
        SDL::delay(2000);
      SKIP:
        {
            skip( "I have no idea why cur_track and cur_frame are 0.", 2 );
            is( $cd->cur_track(), 4, "[SDL::CD->cur_track] is 4" );
            my $frame = $cd->cur_frame();
            ok( $frame, "[SDL::CD->cur_frame] is $frame" );
        }

        my $t_id = $track->id();
        ok( $t_id, "[SDL::CDTrack->id] is $t_id" );
        my $t_type = $track->type();
        ok(
            defined $types{$t_type},
            "[SDL::CDTrack->type] is "
              . ( defined $types{$t_type} ? $types{$t_type} : 'undefined' )
        );
        my $t_length = $track->length();
        ok( $t_length > 0, "[SDL::CDTrack->length] is $t_length" );
        my $t_offset = $track->offset();
        ok( $t_offset > 0, "[SDL::CDTrack->offset] is $t_offset" );

        is( $cd->resume(), 0, "[SDL::CD->resume] succeeded" );
        SDL::delay(2000);
        is( $cd->stop(), 0, "[SDL::CD->stop] succeeded" );
        SDL::delay(2000);
        is( $cd->play( CD_FPS * 30, CD_FPS * 2 ),
            0, "[SDL::CD->play] succeeded" );
        SDL::delay(2000);
    }
  SKIP:
    {
        skip( "CD should be in CD_STOPPED or CD_TRAYEMPTY state", 1 )
          unless $status == CD_STOPPED || $status == CD_TRAYEMPTY;

        is( $cd->eject(), 0, "[SDL::CD->eject] succeeded" )
          unless SDL::delay(2000);
    }
}

done_testing;

sleep(1);

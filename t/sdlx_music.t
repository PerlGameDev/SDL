#!/usr/bin/perl -w
use strict;
use warnings;
use SDL;
use SDL::Config;

my $audiodriver;

BEGIN {
    use Config;
    if ( !$Config{'useithreads'} ) {
        print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
        exit(0);
    }
    require threads;
    require threads::shared;

    use Test::More;
    use lib 't/lib';
    use SDL::TestTool;

    $audiodriver = $ENV{SDL_AUDIODRIVER};
    $ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

    if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
        plan( skip_all => 'Failed to init sound' );
    }
    elsif ( !SDL::Config->has('SDL_mixer') ) {
        plan( skip_all => 'SDL_mixer support not compiled' );
    }
}

use_ok( 'SDLx::Music', "Can load SDLx::Music" );

# Object Creation

can_ok( 'SDLx::Music', 'new' );

my $music = SDLx::Music->new();

#my $music2 = SDLx::Music->new();

isa_ok( $music, "SDLx::Music" );

#isa_ok( $music2, "SDLx::Music" );

# Music Data defination

can_ok( 'SDLx::Music', 'data' );

## Simple
ok( $music->data( silence => 'test/data/silence.wav' ) );

## Long
ok(
    $music->data(
        sample => {
            file    => 'test/data/sample.wav',
            loops   => 2,
            fade_in => 0.5,
            volume  => 72
        },
    )
);


## Check if stuff actually got loaded
my $silence = $music->data('silence');

isa_ok( $silence, "SDLx::Music::Data");
isa_ok( $music->data('sample'), "SDLx::Music::Data");

is_deeply( $silence, $music->{data}->{silence}, "Silence is retreived correctly");
is_deeply( $music->data('sample'), $music->{data}->{sample}, "Sample is retreived correctly");

# Chained changes

can_ok( 'SDLx::Music', 'playing');

$silence->volume(55)->loops(2)->file('test/data/silence.wav'); 

$music->play($silence);

my $played; 
while( $music->playing )
{
	$played = 1 unless $played;
}

is( $played, 1, "Music played and atleast one" ); 	

isa_ok( $music->{data}->{silence}->{_content}, "SDL::Mixer::MixMusic", "Didn't load data for play" );

can_ok(  'SDLx::Music', 'load' );

$music->load;

isa_ok( $music->{data}->{sample}->{_content}, "SDL::Mixer::MixMusic" );

$music->play( $music->data('sample') );

$played = 0;
while( $music->playing )
{
	$played = 1 unless $played;
}

is( $played, 1, "Music played and atleast one" ); 	

is( $silence->{volume}, 55);


# Clear the data 

can_ok ( 'SDLx::Music', 'clear' );

ok( $music->clear );

## Check if we are actually clear

is( $music->{data}, undef, "Is clear" );

# Check default call

can_ok ( 'SDLx::Music', 'default' );

isa_ok( $music->default, "SDLx::Music::Default" );

$music->default->ext('.wav');

isa_ok( SDLx::Music->default, "SDLx::Music::Default" );

SDLx::Music->default->ext('.ogg');

is( $music->default->ext, '.wav' );
is( SDLx::Music->default->ext, '.ogg');

if ($audiodriver) {
    $ENV{SDL_AUDIODRIVER} = $audiodriver;
}
else {
    delete $ENV{SDL_AUDIODRIVER};
}

done_testing();

#!/usr/bin/env perl
#
# This example plays a .WAV sound sample
#
use strict;
use warnings;
use SDL;
use SDL::Mixer;
use SDL::Sound;

SDL::Init(SDL_INIT_AUDIO);

my $filename = shift || 'data/sample.wav';

my $mixer = SDL::Mixer->new(
    -frequency => 44100,
);
print "Using audio driver: ", SDL::AudioDriverName(), "\n";

my $wave = SDL::Sound->new($filename);

# we don't care what channel, and we only want to play it once
my $channel = $mixer->play_channel( -1, $wave, 0 );

# wait until it has finished playing
while ( $mixer->playing($channel) ) {
    SDL::Delay(10);
}


package SDLx::Audio;
use strict;
use warnings;

use Carp ();
use SDL;
use SDL::Audio;
use SDL::Mixer;
use SDL::Mixer::Music;
use SDL::Mixer::Channels;
use SDL::Mixer::Samples;
use SDL::Mixer::MixChunk;

my $has_audio = SDL::Mixer::open_audio( 44100, AUDIO_S16SYS, 2, 4096 ) == 0 ? 1 : 0;

Carp::carp 'Unable to initialize audio: ' . SDL::get_error
    unless $has_audio;


sub play {
    return unless $has_audio;

    my ($chunk, $times, $volume) = @_;
    Carp::croak "play() needs a sound sample as parameter"
        unless $chunk;
    
    $times  ||= 0;
    $volume ||= 10;

    my $channel_number = SDL::Mixer::Channels::play_channel(-1, $chunk, $times )
        or return;

    SDL::Mixer::Channels::volume( $channel_number, $volume)
        if $channel_number >= 0;

    return $channel_number;
}


sub pause {
    
}


sub inc_volume {

}


sub dec_volume {

}


sub load_sound {
    return unless $has_audio;

    my $filename = shift;
    return SDL::Mixer::Samples::load_WAV($filename);
}


sub start_music {
    return unless $has_audio;

    my $filename = shift;
    my $music = SDL::Mixer::Music::load_MUS($filename)
        or Carp::croak 'Music not found: ' . SDL::get_error();

    # play that funky music!
    SDL::Mixer::Music::play_music( $music, -1 );

    SDL::Mixer::Music::volume_music(85);
}


# close our audio on program ending.
# Note that this does *NOT* catch signals
# but then again, neither did our previous
# attempt :)
END {
    SDL::Mixer::close_audio();
}

'all your audio are belong to us';

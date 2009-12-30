#!/usr/bin/perl

#CREDIT TO ruosco

use strict;
use warnings;
use utf8;
use 5.01000;

# we shouldn't use SDL::Timer, because it starts a different thread,
# and the SDL binding doesn't take care of that...
use Time::HiRes;
use Event qw<loop unloop>;



use SDL;
use SDL::App;
use SDL::Mouse;
use SDL::Color;
use SDL::Audio;
use SDL::AudioSpec;
use SDL::Event;
use SDL::Events;
use Devel::Peek;

our $FPS = 40;
our $width = 1280;
our $height = 800;
our $bg_color = SDL::Color->new( 0,  0, 0);
our @objects;

our $app = SDL::App->new
  ( -width => $width,
    -height => $height,
    -depth => 16,
    -resizeable => 1,
    -title => 'Tecla',
  #  -fullscreen => 1
  );

SDL::Mouse::show_cursor(0);

   sub callback{
   my ($int_size, $len, $stream) = @_;

   #warn "call back is running $len \n";
   #Dump $stream;
   my @stream = unpack('c*', $stream);
   #warn "Unpacked is: ", join ', ', @stream , "\n";
#=pod
   foreach my $i (0..$len)
   {
	my $new = rand()*127;
	$stream[$i] = int($new);
 	 	

   }
    #warn "new is: ", join ', ', @stream , "\n";
   $stream = pack ( 'c*x', @stream);
#=cut 
   }

sub setup_audio
{
    my $desired = SDL::AudioSpec->new;
    my $obtained = SDL::AudioSpec->new;
    $desired->freq ( 44100 );
    $desired->format ( AUDIO_U8 );
    $desired->samples ( 4096 );
  
    #$desired->userdata ( NULL );
    $desired->callback( 'main::callback'); #canno
    $desired->channels ( 1 );

    
    die('AudioMixer, Unable to open audio: '.SDL::get_error."\n" ) if ( SDL::Audio::open($desired, $obtained) < 0 );
    

    SDL::Audio::pause(0);

  
}
setup_audio();

sleep(4);
SDL::quit();

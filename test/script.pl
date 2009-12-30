#!/usr/bin/perl

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

   warn "call back is running \n";
   warn "Unpacked is: ", join ', ', unpack('i*', $stream), "\n";
   foreach(0..$len)
   {
	my $new = rand()*120;
 	substr($stream, $_*$int_size, $int_size, pack('i', $new));
 	

   }

   }

sub setup_audio
{
    my $desired = SDL::AudioSpec->new;
    my $obtained = SDL::AudioSpec->new;
    $desired->freq ( 44100 );
    $desired->format ( AUDIO_S8 );
    $desired->samples ( 4096 );
  
    #$desired->userdata ( NULL );
    $desired->callback( 'main::callback'); #canno
    $desired->channels ( 1 );

    
    die('AudioMixer, Unable to open audio: '.SDL::get_error."\n" ) if ( SDL::Audio::open($desired, $obtained) < 0 );
    

    SDL::Audio::pause(0);

  
}
setup_audio();

our $time = $app->ticks;
our $sevent = SDL::Event->new();
our $timer = Event->timer
  ( interval => (1/$FPS),
    cb => sub {
      my $oldtime = $time;
      my $now = $app->ticks;
      SDL::Events::pump_events();
      while (SDL::Events::poll_event($sevent)) {
        my $type = $sevent->type;
        if ($type == SDL_QUIT()) {
          unloop;
        } elsif ($type == SDL_KEYDOWN() &&
                 $sevent->key_sym() == SDLK_ESCAPE) {
          unloop;
        } elsif ($type == SDL_KEYDOWN() &&
                 $sevent->key_sym() == SDLK_F11) {
          $app->fullscreen;
        } elsif ($type == SDL_VIDEORESIZE()) {
          $app->resize($sevent->resize_w, $sevent->resize_h);
          $height = $app->height;
          $width = $app->width;
        } else {
          my $x = int(rand($width));
          my $y = int(rand($height));
          my $r = int(rand(255));
          my $g = int(rand(255));
          my $b = int(rand(255));
          my $s = int(rand(20))+20;
          my $t = int(rand(1700))+300;

          my $tone = int(rand(24))-12; # produce one octave higher and
                                       # one lower than the base
          my $freq = 440 *             # start on A4
            ((2 ** (1/12)) ** $tone);  # formula took from:
          # http://www.phy.mtu.edu/~suits/NoteFreqCalcs.html

          push @objects, Tecla::Object->new
            ({ rect => SDL::Rect->new( $x,  $y,  $s, $s),
               start_color => SDL::Color->new( $r,  $g, $b),
               started => $time,
               duration => $t,
               freq => $freq });
        }
      }


      @objects = grep { $_->time_lapse($oldtime,$now) } @objects;

      my $rect = SDL::Rect->new(0, 0, $width, $height);
      ;
      SDL::Video::fill_rect($app, $rect, SDL::Video::map_RGB($app->format, 0,0,0));

      $_->draw() for @objects;

      SDL::Video::flip($app);
      $time = $app->ticks;
    });

loop;

exit;

package Tecla::Object;
use strict;
use warnings;
use base 'Class::Accessor';

BEGIN {
  __PACKAGE__->mk_accessors(qw(rect started duration time_to_live
                               start_color color freq audio));
}

sub new {
  my $self = shift;
  $self = $self->SUPER::new(@_);
  return $self;
}

sub time_lapse {
  my ($self, $oldtime, $now) = @_;
  $self->time_to_live(($self->started + $self->duration) - $now);
  if ($self->time_to_live > 0) {
    my $percent = $self->time_to_live / $self->duration;
    $self->color
      ( SDL::Color->new
        (  $self->start_color->r * $percent,
          $self->start_color->g * $percent,
           $self->start_color->b * $percent ));
    return 1;
  } else {
    return 0;
  }
}

sub draw {
  my $self = shift;
  SDL::Video::fill_rect($app, $self->rect, SDL::Video::map_RGB($app->format, $self->color->r , $self->color->b, $self->color->g) );
}



1;

__END__
__C__

#include <math.h>
#include <SDL/SDL.h>
#include <SDL/SDL_main.h>

SDL_AudioSpec *desired, *obtained;

void produce_audio_output(void *unused, Uint8 *stream, int len) {
  // random noise to test the system...
  int i;
  for (i = 0; i < len; i++) {
    stream[i] = rand()*120;
  }
}



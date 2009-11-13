#!/usr/bin/perl -w
use strict;
use warnings;
use lib '.';
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Video;

SDL::init(SDL_INIT_VIDEO);
my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
my  $event = SDL::Event->new();

 #This filters out all ActiveEvents
my $filter = sub { if($_[0]->type == SDL_ACTIVEEVENT){ return 0} else{ return 1; }};
my $filtered = 1;

SDL::Events::set_event_filter($filter);

while(1)
{

  SDL::Events::pump_events();
  if(SDL::Events::poll_event($event))
  {
  if(  $event->type == SDL_ACTIVEEVENT)
	{
	$filtered = 0; #we got a problem!
	print "Hello Mouse!!!\n" if ($event->active_gain && ($event->active_state == SDL_APPMOUSEFOCUS) );
	print "Bye Mouse!!!\n" if (!$event->active_gain && ($event->active_state == SDL_APPMOUSEFOCUS) );
        }
  if( $event->type == SDL_MOUSEBUTTONDOWN)
  	{
	my ($x, $y, $but, $wh ) = ($event->button_x, $event->button_y, $event->button_button, $event->button_which);
	warn "$but $wh  CLICK!!! at $x and $y \n";
	}
  exit if($event->type == SDL_QUIT);
  }
}
SDL::quit();


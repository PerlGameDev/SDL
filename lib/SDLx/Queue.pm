package SDLx::Queue;
use strict;
use warnings;
use Carp;
use SDL;
use SDL::Event;
use SDL::Events;

use Data::Dumper;


sub enqueue
{
  my ($queue_name, $event) = @_;


my $userdata = SDL::Event->new();
$userdata->type(SDL_USEREVENT);
$userdata->user_data1( $queue_name );
$userdata->user_data2( $event );

  if( SDL::Events::push_event( $userdata ) < 0 )
  {
	  Carp::carp 'Cannot push_event :'.SDL::get_error();
  }

  return $userdata;

}

sub dequeue
{
   my ($queue_name) = @_;

   my $peep_event = SDL::Event->new();
   my $event = SDL::Event->new();

   my $queue_ref = '';
   my $data_ref = '';

   SDL::Events::pump_events;
  while( my $peepd = SDL::Events::peep_events( $peep_event, 1, SDL_GETEVENT, SDL_ALLEVENTS ) )
  {
	  return -1 if $peepd == 0;

	  if ($peepd == -1) { Carp::croak 'Cannot peep events : '.SDL::get_error(); };
	 
	  if (  $peep_event->type == SDL_USEREVENT) 
	  {
		  $queue_ref = $peep_event->user_data1;
		  $data_ref = $peep_event->user_data2;	   	   
		  if( defined $queue_ref && $$queue_ref eq $queue_name )
	  	  { 
		 	return $$data_ref ;
		  }
		  else
		  {
		
			  SDL::Events::peep_events( $peep_event, 1, SDL_ADDEVENT, SDL_ALLEVENTS )

		  }
	   }


  }
   return $data_ref;

}


1;



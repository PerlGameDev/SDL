package SDL::Tutorial::MoP::View::Game;

use strict;
use warnings;
use Data::Dumper;
use Carp;

use base 'SDL::Tutorial::MoP::Base';

use SDL;
use SDL::Video;
use SDL::Rect;

my $screen_width  = 800;
my $screen_height = 600;

my $map;
my $view_rect     = SDL::Rect->new(0, 0, $screen_width, $screen_height);

sub init 
{
    my $self = shift;
    
	SDL::init(SDL_INIT_VIDEO);

	$self->{app} = SDL::Video::set_video_mode( $screen_width, $screen_height, 32, SDL_SWSURFACE);
	$map         = SDL::Tutorial::MoP::Model::Map->new();
	
	$self->clear();
}

sub notify 
{
    my ($self, $event) = (@_);

    print "Notify in View Game \n" if $self->{EDEBUG};

    #if we did not have a tick event then some other controller needs to do
    #something so game state is still beign process we cannot have new input
    #now
    return if !defined $event;

    my %event_action = (
        'Tick' => sub {
            frame_rate(1) if $self->{FPS};
        },
        'MapBuilt' => sub {
            $self->{'map'} = $event->{map};
        },
        'GameStart' => sub {
            $self->{game} = $event->{game};
            $self->draw_scene() if $self->{map};
        },
        'MapMove' => sub {
            $self->clear();
            $self->draw_scene() if ($self->{map} && $self->{map});
        },
    );

    my $action = $event_action{$event->{name}};
    
    if (defined $action) {
        print "Event $event->{name}\n" if $self->{GDEBUG};
        $action->();
    }

}

sub clear 
{
    my $self = shift;
#    $self->draw_rectangle(0, 0, $self->{app}->width, $self->{app}->height,
#        $palette{background});
}

sub draw_map
{
	my $self = shift;
	
	carp('There is no surface to draw to') unless $self->{app};	
	carp('There are no tiles to draw')     unless $map->tiles;	

	# blitting the whole map-surface to app-surface
	unless($map->is_up_to_date)
	{
		SDL::Video::blit_surface( $map->surface, $map->rect, $self->{app}, $view_rect );
		$map->is_up_to_date(0);
	}	

    return 1;
}

sub draw_scene 
{
    my $self = shift;
    my $game = $self->{game};
    
    $self->draw_map();
    
	carp('There is no surface to draw to') unless $self->{app};

    SDL::Video::update_rect( $self->{app}, 0, 0, $screen_width, $screen_height );
}

# Should be in Game::Utility
my $frame_rate = 0;
my $time       = time;

sub frame_rate 
{
    my $secs = shift || 2;
    my $fps  = 0;
    $frame_rate++;

    my $elapsed_time = time - $time;
    if ($elapsed_time > $secs)
    {
        $fps = ($frame_rate / $secs);
        print "Frames per second: $frame_rate\n";
        $frame_rate = 0;
        $time       = time;
    }
    return $fps;
}

1;

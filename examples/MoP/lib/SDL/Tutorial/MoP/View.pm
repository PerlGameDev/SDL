package SDL::Tutorial::MoP::View::Game;

use strict;
use warnings;
use Data::Dumper;
use Carp;
use Time::HiRes qw(usleep);

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
            $self->draw_scene();
        },
        'MapMove' => sub {
            $self->clear();
            $self->draw_scene();
        },
        'MapMoveRequest' => sub {
            $self->clear();
            $self->map_move($event->{direction});
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

sub map_move_rel
{
	my $self = shift;
	my $_x   = shift;
	my $_y   = shift;
	
	my $step = $_x > 0 ? 1 : -1;
	
	for(my $x = 0; $x != $_x; $x += $step)
	{
		$map->x($map->x() + $step);
		$self->draw_scene();
		#usleep(1000);
	}
	
	$step = $_y > 0 ? 1 : -1;
	
	for(my $y = 0; $y != $_y; $y += $step)
	{
		$map->y($map->y() + $step);
		$self->draw_scene();
		#usleep(1000);
	}
}

sub map_move
{
	my $self      = shift;
	my $direction = shift;
	
	$self->map_move_rel(+16, 0) if $direction eq 'RIGHT';
	$self->map_move_rel(-16, 0) if $direction eq 'LEFT';
	$self->map_move_rel(0, -16) if $direction eq 'UP';
	$self->map_move_rel(0, +16) if $direction eq 'DOWN';
}

sub draw_map
{
	my $self = shift;
	
	carp('There is no surface to draw to') unless $self->{app};	
	carp('There are no tiles to draw')     unless $map->tiles;	

	# blitting the whole map-surface to app-surface
	my $srect = SDL::Rect->new(0, 0, $map->w(), $map->h()); #we want all of map;
	my $drect = SDL::Rect->new($map->x(), $map->y(), $screen_width, $screen_height);
	
	unless($map->is_up_to_date)
	{
		SDL::Video::blit_surface( $map->surface, $srect, $self->{app}, $drect );
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

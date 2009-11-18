package SDL::Tutorial::MoP::View::Game;

use strict;
use warnings;
use Data::Dumper;
use Carp;

use base 'SDL::Tutorial::MoP::Base';

use SDL;
use SDL::App;

my $screen_width  = 800;
my $screen_height = 600;

sub init 
{
    my $self = shift;
    
	SDL::init(SDL_INIT_VIDEO);

	$self->{app} = SDL::Video::set_video_mode( $screen_width, $screen_height, 32, SDL_SWSURFACE);
	
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

sub show_map 
{
    my $self = shift;

#     // Calculate the limits of the board in pixels
#    my $x1 = $self->{'map'}->get_x_pos_in_pixels(0);
#    my $x2 = $self->{'map'}->get_x_pos_in_pixels($self->{'map'}->{width});
#    my $y =
#      $self->{app}->height
#      - ($self->{'map'}->{block_size} * $self->{'map'}->{height});

#    $self->draw_rectangle(
#        $x1 - $self->{grid}->{board_line_width},
#        $y,
#        $self->{grid}->{board_line_width},
#        $self->{app}->height - 1,
#        $palette{lines},
#    );

#
#    $self->draw_rectangle(
#        $x2, $y,
#        $self->{grid}->{board_line_width},
#        $self->{app}->height - 1,
#        $palette{lines},
#    );

#    my $color;
#    for (my $i = 0; $i < ($self->{'map'}->{width}); $i++) {
#        for (my $j = 0; $j < $self->{'map'}->{height}; $j++) {

            # Check if the block is filled, if so, draw it
#            my $color = $self->{grid}->is_free_loc($i, $j) ? $palette{free}
#                                                           : $palette{blocked};

#            $self->draw_rectangle(
#                $self->{grid}->get_x_pos_in_pixels($i),
#                $self->{grid}->get_y_pos_in_pixels($j),
#                $self->{grid}->{block_size} - 1,
#                $self->{grid}->{block_size} - 1,
#                $color
#            );

#        }
#    }
}

#needs the charactor now
sub show_charactor    # peice
{
#    my $self = shift;
#    die 'Expecting 4 arguments' if ($#_ != 3);

#    my ($x, $y, $piece, $rotation) = @_;
#    my $pixels_x = $self->{'map'}->get_x_pos_in_pixels($x);
#    my $pixels_y = $self->{'map'}->get_y_pos_in_pixels($y);

#    for (my $i = 0; $i < 5; $i++) {
#        for (my $j = 0; $j < 5; $j++) {

            # Get the type of the block and draw it with the correct color
#            my $color = SDL::Tutorial::Tetris::Model::Pieces->block_color($piece, $rotation, $j, $i);
#            if (defined $color and $palette{$color}) {
#                my $block_size = $self->{grid}->{block_size};
#                $self->draw_rectangle(
#                    $pixels_x + $i * $block_size,
#                    $pixels_y + $j * $block_size,
#                    $block_size - 1,
#                    $block_size - 1,
#                    $palette{$color},
#                );
#            }
#        }
#    }

}

sub draw_map
{
	my $self = shift;
	my $map  = SDL::Tutorial::MoP::Model::Map->new();
	
	$map->move_map('LEFT');

	my $x_offset = 0;#$map->map_center[0] - ($screen_width  / $map->tile_size / 2);
	my $y_offset = 0;#$map->map_center[1] - ($screen_height / $map->tile_size / 2);

	   $y_offset = 0 if($y_offset < 0);
	   $x_offset = 0 if($x_offset < 0);

	$screen_width  = 640;
	$screen_height = 480;
	
	carp('There is no surface to draw to') unless $self->{app};	
	carp('There are no tiles to draw')     unless $map->tiles;	

	for (my $y = 0; $y < $screen_height / $map->tile_size; $y++)
	{
		for (my $x = 0; $x < $screen_width / $map->tile_size; $x++)
		{
	    	my $tiles_rect  = $map->get_tile($x + $x_offset, $y + $y_offset);
	    	my $screen_rect = SDL::Rect->new($x * $map->tile_size, $y * $map->tile_size, 
	    	                                 $screen_width, $screen_height);
	
	    	SDL::Video::blit_surface( $map->tiles, $tiles_rect, $self->{app}, $screen_rect );
		}
	}

    return 1;
}

sub draw_scene 
{
    my $self = shift;
    my $game = $self->{game};
    
    #print($self->{app} . "\n");

    $self->draw_map();
    
#    $self->show_charactor(
#        $game->{posx},  $game->{posy},
#        $game->{piece}, $game->{pieceRotation}
#    );
#    $self->show_charactor(
#        $game->{next_posx},  $game->{next_posy},
#        $game->{next_piece}, $game->{next_rotation}
#    );

	carp('There is no surface to draw to') unless $self->{app};

    SDL::Video::update_rect( $self->{app}, 0, 0, $screen_width, $screen_height );
}

sub draw_rectangle 
{
    my $self = shift;
#    die 'Expecting 5 parameters got: ' . $#_ if ($#_ != 4);
#    my ($x, $y, $w, $h, $color) = @_;
#    my $box = SDL::Rect->new(-x => $x, -y => $y, -w => $w, -h => $h);
#    $self->{app}->fill($box, $color);

    #print "Drew rect at ( $x $y $w $h ) \n";
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

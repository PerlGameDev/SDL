package SDL::Tutorial::MoP::Model::Map;

use strict;
use warnings;

use base 'SDL::Tutorial::MoP::Base';

use File::ShareDir qw(module_file);
use Carp;

use SDL;
use SDL::Video;
use SDL::Tutorial::MoP::Models;

#BEGIN {
#    use Exporter ();
#    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
#    $VERSION     = '0.01';
#    @ISA         = qw(Exporter);
#    #Give a hoot don't pollute, do not export more than needed by default
#    @EXPORT      = qw();
#    @EXPORT_OK   = qw(draw_map);
#    %EXPORT_TAGS = ();
#}

use constant
{
	MOP_TOP    => 0,
	MOP_BOTTOM => 1,
	MOP_RIGHT  => 2,
	MOP_LEFT   => 3	
};

my $screen_width  = 640;
my $screen_height = 480;
my $tile_size     = 10;
my $model         = new SDL::Tutorial::MoP::Models;
my @map           = $model->map();

my @map_center    = (32, 24); # x, y

my $path          = module_file('SDL::Tutorial::MoP', 'data/tiles.bmp');
my $tiles         = SDL::Video::load_BMP($path);
croak 'Error: '.SDL::get_error() if(!$tiles);

sub new
{
	my ($class, %params) = (@_);

	my $self = $class->SUPER::new(%params);

	$self->evt_manager->reg_listener($self);
	$self->init(%params);

	return $self;
}

sub init 
{
    my ($self, %params) = @_;
    
	#SDL::init(SDL_INIT_VIDEO);

	#$self->{app} = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE);
	
	$self->{map} ||= [];
}

sub notify
{
    my ($self, $event) = (@_);
 
    print "Notify in Map \n" if $self->{EDEBUG};
 
    if (defined $event && $event->{name} eq 'Tick')
    {
        #do checks
    }
}

sub draw_map
{
	my $self = shift;
	
	move_map(MOP_LEFT);

	my $x_offset = $map_center[0] - ($screen_width  / $tile_size / 2);
	my $y_offset = $map_center[1] - ($screen_height / $tile_size / 2);

	   $y_offset = 0 if($y_offset < 0);
	   $x_offset = 0 if($x_offset < 0);

	for (my $y = 0; $y < $screen_height / $tile_size; $y++)
	{
		for (my $x = 0; $x < $screen_width / $tile_size; $x++)
		{
	    	my $tiles_rect  = get_tile(${$map[$y + $y_offset]}[$x + $x_offset] ? 5 : 6);
	    	my $screen_rect = SDL::Rect->new($x * $tile_size, $y * $tile_size, 
	    	                                 $screen_width, $screen_height);
	
	    	SDL::Video::blit_surface( $tiles, $tiles_rect, $self->{app}, $screen_rect );
		}
	}
			$self->{app} = 'hallo';
    #SDL::Video::update_rect( $self->{app}, 0, 0, $screen_width, $screen_height ); 

	#sleep(5);

    return 1;
}

sub move_map
{
	my $direction = shift;
	
	$map_center[0]++ if $direction == MOP_LEFT;
	$map_center[0]-- if $direction == MOP_RIGHT;
	$map_center[1]++ if $direction == MOP_TOP;
	$map_center[1]-- if $direction == MOP_BOTTOM;
}

sub get_tile
{
	my $index = shift || 0;	

	carp 'Unable to load tiles ' . SDL::get_error() if(!$tiles);

	my $x = ($index * $tile_size) % $tiles->w;
	my $y = int(($index * $tile_size) / $tiles->w) * $tile_size;
	
  	return SDL::Rect->new($x, $y, $tile_size, $tile_size);
}

1;

package SDL::Tutorial::MoP::View::Map;
use strict;
use SDL;
use SDL::App;
use SDL::Event;
use SDL::Video;
use File::Spec::Functions qw(rel2abs splitpath catpath catfile);
use Carp;
use SDL::Tutorial::MoP::Models;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw(draw_map);
    %EXPORT_TAGS = ();
}

use constant
{
	MOP_TOP    => 0,
	MOP_BOTTOM => 1,
	MOP_RIGHT  => 2,
	MOP_LEFT   => 3	
};

my $screen;
my $screen_width  = 640;
my $screen_height = 480;
my $tile_size     = 10;
my $model         = new SDL::Tutorial::MoP::Models;
my @map           = $model->map();

my @map_center    = (32, 24); # x, y

my ($volume, $dirs) = splitpath(rel2abs(__FILE__));
my $diff = 'MoP/../../';
 $diff = '../' if ($^O =~ /linux/);
my $path            = catpath($volume, catfile($dirs, $diff.'tiles.bmp'));
my $tiles           = SDL::Video::load_BMP($path);
croak 'Error: '.SDL::get_error() if(!$tiles);

sub draw_map
{
	carp 'Unable to init SDL: ' . SDL::get_error() if(SDL::init(SDL_INIT_VIDEO) < 0);

	$screen = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE);

	carp 'Unable to set 640x480x32 video ' . SDL::get_error() if(!$screen);

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
	
	    	SDL::Video::blit_surface( $tiles, $tiles_rect, $screen, $screen_rect );
		}
	}
    SDL::Video::update_rect( $screen, 0, 0, $screen_width, $screen_height ); 

	sleep(5);

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

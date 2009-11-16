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

my $screen;
my $model = new SDL::Tutorial::MoP::Models;
my @map   = $model->map();

sub draw_map
{
	carp 'Unable to init SDL: ' . SDL::get_error() if(SDL::init(SDL_INIT_VIDEO) < 0);

	$screen = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE);

	carp 'Unable to set 640x480x32 video ' . SDL::get_error() if(!$screen);

	my ($volume, $dirs) = splitpath(rel2abs(__FILE__));
	my $path            = catpath($volume, $dirs, catfile('MoP', '../../', 'tiles.bmp'));
    my $tiles = SDL::Video::load_BMP($path);

	carp 'Unable to load tiles ' . SDL::get_error() if(!$tiles);

	for (my $y = 0; $y < 48; $y++)
	{
		for (my $x = 0; $x < 64; $x++)
		{
	    	my $tiles_rect  = SDL::Rect->new (${$map[$y]}[$x] ? 40 : 50, 0, 10, 10);
	    	my $screen_rect = SDL::Rect->new ($x * 10, $y * 10, 640, 480);
	
	    	SDL::Video::blit_surface( $tiles, $tiles_rect, $screen, $screen_rect );
		}
	}
    SDL::Video::update_rect( $screen, 0, 0, 640, 480 ); 

	sleep(5);

    return 1;
}

1;

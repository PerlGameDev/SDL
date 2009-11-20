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

my $tile_size     = 10;
my @map           = ();

my $path          = module_file('SDL::Tutorial::MoP', 'data/tiles.bmp');
my $tiles         = SDL::Video::load_BMP($path);
croak 'Error: '.SDL::get_error() if(!$tiles);

my $map_surface;       # the image(s) of the current map are here
my $map_rect;
my $is_up_to_date = 0;

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
    
    $self->load_map() || carp("load_map() failed");
    $map_rect = SDL::Rect->new( 0, 0, 800, 600); # TODO we need global screen dimensions
    
	$self->{map} ||= [];
}

sub notify
{
    my ($self, $event) = (@_);
 
    print carp(sprintf("Notify '%s'in Map", $event->{name})) if $self->{EDEBUG};
 
    my %event_action = (
        'MapMoveRequest' => sub {
            $self->move_map($event->{direction}) if $map_rect;
            $self->evt_manager->post({ name => 'MapMove' });
        },
    );

    my $action = $event_action{$event->{name}};
    
    if (defined $action) {
        print "Event $event->{name}\n" if $self->{GDEBUG};
        $action->();
    }
}

sub move_map
{
	my $self      = shift;
	my $direction = shift;
	
	carp($map_rect->x . "x" . $map_rect->y);

	$map_rect->x($map_rect->x + 1) if $direction eq 'LEFT';
	$map_rect->x($map_rect->x - 1) if $direction eq 'RIGHT';
	$map_rect->y($map_rect->y + 1) if $direction eq 'UP';
	$map_rect->y($map_rect->y - 1) if $direction eq 'DOWN';
	
	return;
	
	$self->rect->x($self->rect->x + 1) if $direction eq 'LEFT';
	$self->rect->x($self->rect->x - 1) if $direction eq 'RIGHT';
	$self->rect->y($self->rect->y + 1) if $direction eq 'UP';
	$self->rect->y($self->rect->y - 1) if $direction eq 'DOWN';
	
}

# loads the bitmap file into $self->surface and also the tile-definitions into @map
sub load_map
{
	my $self = shift;
#	my $_path = module_file('SDL::Tutorial::MoP', 'data/main.map');
#	open (FH, $_path)  || die "Can not open file $path: $!";
#	while(<FH>)
#	{
#		my @_row = split(//, $_);
#		push(@map, \@_row);
#	}
#	close(FH);
#	return @map;

	my $_path    = module_file('SDL::Tutorial::MoP', 'data/main.bmp');
	#my $_surface = SDL::Video::load_BMP($_path);
	my $_surface = SDL::IMG_Load($_path);
	
	if($_surface)
	{
		$self->surface($_surface);
		$is_up_to_date = 0;
		$_surface      = undef;
		return 1;
	}
	else
	{
		carp("Could not load bitmap $_path.");
		return -1;
	}
}

sub get_tile
{
	my $self = shift;
	my $x    = shift;
	my $y    = shift;
	
#	return $self->get_tile_by_index(${$map[$y + $map_center[1]]}[$x + $map_center[0]] ? 5 : 6);
}

sub get_tile_by_index
{
	my $self = shift;
	my $index = shift || 0;

	carp 'Unable to load tiles ' . SDL::get_error() if(!$tiles);

	my $x = ($index * $tile_size) % $tiles->w;
	my $y = int(($index * $tile_size) / $tiles->w) * $tile_size;
	
  	return SDL::Rect->new($x, $y, $tile_size, $tile_size);
}

sub tile_size
{
	my $self   = shift;
	$tile_size = shift || return $tile_size;
}

sub tiles
{
	my $self = shift;
	$tiles   = shift || return $tiles;
}

sub surface
{
	my $self     = shift;
	$map_surface = shift || return $map_surface;
}

sub rect
{
	my $self  = shift;
	$map_rect = shift || return $map_rect;
}

sub is_up_to_date
{
	my $self       = shift;
	$is_up_to_date = shift || return $is_up_to_date;
}

1;

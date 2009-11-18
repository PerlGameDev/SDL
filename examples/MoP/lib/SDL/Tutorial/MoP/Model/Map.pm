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

my $tile_size     = 10;
my @map           = ();

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
    
    @map = $self->load_map();
    
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

sub move_map
{
	my $direction = shift;
	
	$map_center[0]++ if $direction == MOP_LEFT;
	$map_center[0]-- if $direction == MOP_RIGHT;
	$map_center[1]++ if $direction == MOP_TOP;
	$map_center[1]-- if $direction == MOP_BOTTOM;
}

sub load_map
{
	my $path = module_file('SDL::Tutorial::MoP', 'data/main.map');
	open (FH, $path)  || die "Can not open file $path: $!";
	while(<FH>)
	{
		my @row = split(//, $_);
		push(@map, \@row);
	}
	close(FH);
	
	return @map;
}

sub get_tile
{
	my $self = shift;
	my $x    = shift;
	my $y    = shift;
	
	return $self->get_tile_by_index(${$map[$y]}[$x] ? 5 : 6);
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
	my $self = shift;
	$tile_size = shift || return $tile_size;
}

sub tiles
{
	my $self = shift;
	$tiles = shift || return $tiles;
}



1;

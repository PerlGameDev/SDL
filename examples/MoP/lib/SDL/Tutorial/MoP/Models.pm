package SDL::Tutorial::MoP::Models;
use strict;
use File::ShareDir        qw(module_file);
use Cwd                   qw(abs_path);
use Data::Dumper;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw(map);
    @EXPORT_OK   = qw(map);
    %EXPORT_TAGS = ();
}

my @map    = (); # bool values where we can go
my @frame  = (); # tile gfx definitions
my $avatar = { x=> 0, y=> 0, face=>0 } ; # player pos

sub new
{
    my ($class, %parameters) = @_;
    my $self = bless ({}, ref ($class) || $class);
    
    load_map() or die("Can't load map.");
    
    return $self;
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
}

sub map
{
	return @map;
}

1;

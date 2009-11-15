package SDL::Tutorial::MoP::Models;
use strict;
use File::Spec::Functions qw(rel2abs splitpath catpath);
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
my @avatar = (); # player pos

my ($volume, $dirs) = splitpath(rel2abs(__FILE__));
my $path            = catpath($volume, $dirs, 'main.map');

sub new
{
    my ($class, %parameters) = @_;
    my $self = bless ({}, ref ($class) || $class);
    
    load_map() or die("Can't load map.");
    
    return $self;
}

sub load_map
{
	open (FH, $path)  || die "Can not open file $_: $!";
	while(<FH>)
	{
		push(@map, split(//, $_));
	}
	close(FH);
}

sub map
{
	return @map;
}

1;
# The preceding line will help the module return a true value


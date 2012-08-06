package SDL::Internal::Loader;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT @LIBREFS);
require Exporter;
our @ISA     = qw(Exporter);
our @EXPORT  = qw(internal_load_dlls);
our @LIBREFS = ();

our $VERSION = '2.541_09';
$VERSION = eval $VERSION;

use SDL::ConfigData;
use Alien::SDL;

# SDL::Internal::Loader is a king of "Dynaloader kung-fu" that is
# necessary in situations when you install Allien::SDL from sources
# or from prebuilt binaries as in these scenarios the SDL stuff is
# installed into so called 'sharedir' somewhere in perl/lib/ tree
# on Windows box it is e.g.
# C:\strawberry\perl\site\lib\auto\share\dist\Alien-SDL...
#
# What happens is that for example XS module "SDL::Video" is linked
# with -lSDL library which means that resulting "Video.(so|dll)" has
# a dependency on "libSDL.(so|dll)" - however "libSDL.(so|dll)" is
# neither in PATH (Win) or in LD_LIBRARY_PATH (Unix) so Dynaloader
# will fail to load "Video.(so|dll)".
#
# To handle this we have internal_load_dlls() which has to be called
# from XS modules (e.g. SDL::Video) linked with SDL libs like this:
#
# use SDL::Internal::Loader;
# internal_load_dlls(PACKAGE);

sub internal_load_dlls($) {
	my $package = shift;
	### check if some ld_shlib_map is defined
	my $shlib_map = Alien::SDL->config('ld_shlib_map');
	return unless $shlib_map; # empty shlib_map, nothing to do

	### get list of lib nicknames based on packagename
	my $lib_nick = SDL::ConfigData->config('SDL_lib_translate')->{$package};
	return unless $lib_nick;  # no need to load anything

	### let us load the corresponding shlibs (*.dll|*.so)
	require DynaLoader;
	foreach my $n (@$lib_nick) {
		my $file = $shlib_map->{$n};
		next unless $file && -e $file;
		my $libref = DynaLoader::dl_load_file( $file, 0 );
		push( @DynaLoader::dl_librefs, $libref ) if $libref;
		push( @LIBREFS,                $libref ) if $libref;
	}
}

1;

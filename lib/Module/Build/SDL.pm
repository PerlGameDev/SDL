package Module::Build::SDL;
use strict;
use warnings;
use base 'Module::Build';
use vars qw($VERSION);

our $VERSION = '2.541_10';
$VERSION = eval $VERSION;

__PACKAGE__->add_property( parinput  => '' );
__PACKAGE__->add_property( paroutput => '' );
__PACKAGE__->add_property( parlibs   => [qw/SDL SDL-1.2 SDLmain/] );
__PACKAGE__->add_property( parmods   => [] );

use File::Spec;
use File::Find qw[finddepth];
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Alien::SDL;

sub new {
	my $self = shift;
	my %args = @_;
	$args{share_dir} ||= 'data'; #set default sharedir name 'data' instead of 'share'
	$self->SUPER::new(%args);
}

sub ACTION_par {
	my ($self) = @_;
	$self->depends_on('code');
	$self->depends_on('installdeps');

	#checking if we have the pp installed
	die 'Need PAR::Packer' if !( eval ' use PAR::Packer; 1' );

	#here comes the code from https://github.com/PerlGameDev/SDL-Par-Packager/blob/master/SDLpp.pl
	my $output   = $self->paroutput || ( ( $^O eq 'MSWin32' ) ? 'a.exe' : 'a' );
	my $input    = $self->parinput;
	my @sdl_libs = @{ $self->parlibs };
	my $extra    = join ' ', ( map {"-M$_"} @{ $self->parmods } );              # = '-MModname::A -MModname::B ...'
	my $Include  = './lib';

	die 'parinput needs to be specified' unless $input;

	print "BUILDING PAR \n";
	my $exclude_modules = '-X Alien::SDL::ConfigData -X SDL::ConfigData';
	my $include_modules = '-M ExtUtils::CBuilder::Base -M Data::Dumper -M SDL -M Alien::SDL';
	$include_modules .= " $extra" if $extra;

	my $out_par = $output . '.par';
	my $par_cmd = "pp -B $exclude_modules $include_modules";
	$par_cmd .= " -I $Include" if $Include;
	$par_cmd .= " -p -o $out_par $input";
	print "\t $par_cmd \n";
	`$par_cmd` if !-e $out_par;

	print "PAR: $out_par\n" if -e $out_par;

	print "SEARCHING FOR ConfigData files \n";
	my $lib;
	my $AS_path;
	my $SD_path;

	finddepth(
		sub {
			my ( $f, $d ) = ( $File::Find::name, $File::Find::dir );
			if ( $_ =~ /ConfigData/ ) {
				$AS_path = $f if $f =~ 'Alien/SDL/ConfigData.pm';
				$SD_path = $f if $f =~ 'SDL/ConfigData.pm' && $f !~ 'Alien/SDL/ConfigData.pm';
				$lib = $d if ( $AS_path && $SD_path );
			}
		},
		@INC
	);

	die "Cannot find lib/SDL/ConfigData.pm or lib/Alien/SDL/ConfigData.pm \n" if ( !$AS_path || !$SD_path );

	print "Found ConfigData files in $lib \n";

	print "READING PAR FILE \n";

	my $par_file = Archive::Zip->new();
	unless ( $par_file->read($out_par) == AZ_OK ) {
		die 'read error on ' . $out_par;
	}

	$par_file->addFile( $AS_path, 'lib/Alien/SDL/ConfigData.pm' );
	$par_file->addFile( $SD_path, 'lib/SDL/ConfigData.pm' );

	my $share = Alien::SDL::ConfigData->config('share_subdir');

	my @shares = $par_file->membersMatching($share);

	my $alien_sdl_auto = $shares[0]->fileName;

	$alien_sdl_auto =~ s/$share(\S+)// if $alien_sdl_auto;

	my @auto_folder = $par_file->membersMatching("$alien_sdl_auto(?!$share)");

	my @sdl_not_runtime = $par_file->membersMatching( $share . '/include' ); #TODO remove extra fluff in share_dri
	push @sdl_not_runtime, @auto_folder;                                                     #remove non share dir stuff
	push @sdl_not_runtime, $par_file->membersMatching( $share . '/etc' );
	push @sdl_not_runtime, $par_file->membersMatching( $share . '/share' );
	push @sdl_not_runtime, $par_file->membersMatching( $share . '/lib' ) if $^O eq 'MSWin32';

	my @non              = ();
	my @sdl_libs_to_keep = ();

	foreach (@sdl_libs) {
		if ( $^O eq 'MSWin32' ) {
			@non = $par_file->membersMatching( $share . "/bin(\\S+)" );

			#push @sdl_not_runtime ,$par_file->membersMatching( $share."/bin(\\S+)(?!$_)" )
		} else {
			@non = $par_file->membersMatching( $share . "/lib(\\S+)" );
		}

		print "Removing non $_ shared objs \n";
		my $lib_look = 'lib' . $_;
		map {
			my $n = $_->fileName;
			if ( $n =~ /$lib_look\.(so|a|dll|dylib)/ ) {
				push( @sdl_libs_to_keep, $_ );
			}
		} @non;
	}

	print "found $#sdl_libs_to_keep sdl libs to keep \n";
	my $regex_search = ']';
	map {
		print "\t " . $_->fileName . "\n";
		$regex_search .= ']' . $_->fileName
	} @sdl_libs_to_keep;

	$regex_search =~ s/\]\]//g;
	$regex_search =~ s/\]/\|/g;

	$regex_search = '(' . $regex_search . ')';

	map {
		my $n    = $_->fileName;
		my $star = ' ';

		if ( $n !~ $regex_search ) {
			push @sdl_not_runtime, $_;
		}
	} @non;

	push @sdl_not_runtime, $par_file->membersMatching( $share . '/bin' )
		unless $^O eq 'MSWin32';
	print "REMOVING NON RUNTIME $#sdl_not_runtime files from  \n";
	open( my $FH, '>', 'DeleteRecords.txt' ) or die $!;
	foreach (@sdl_not_runtime) {
		if ( $_->fileName eq $alien_sdl_auto . $share ) {
			print $FH "Not deleting " . $_->fileName . " \n";
		} else {
			$par_file->removeMember($_);
			print $FH $_->fileName . "\n";
		}
	}
	close $FH;

	my @config_members = $par_file->membersMatching('ConfigData.pm');

	foreach (@config_members) {
		$_->desiredCompressionLevel(1);
		$_->unixFileAttributes(0644);
	}

	unlink $out_par . '2';
	unless ( $par_file->writeToFileNamed( $out_par . '2' ) == AZ_OK ) {
		die 'write error';
	}

	$par_cmd = "pp -o $output " . $out_par . "2";

	`$par_cmd`;

	print "MADE $output \n" if -e $output;
	unlink $out_par . '2';
	unlink $out_par;
}

sub ACTION_run {
	my ($self) = @_;
	$self->depends_on('code');
	$self->depends_on('installdeps');
	my $bd = $self->{properties}->{base_dir};

	# prepare INC
	local @INC  = @INC;
	local @ARGV = @{ $self->args->{ARGV} };
	my $script = shift @ARGV;
	unshift @INC, ( File::Spec->catdir( $bd, $self->blib, 'lib' ), File::Spec->catdir( $bd, $self->blib, 'arch' ) );

	if ($script) {

		# scenario: ./Build run bin/scriptname param1 param2
		do($script);
	} else {

		# scenario: ./Build run
		my ($first_script) = ( glob('bin/*') ); # take the first script in bin subdir
		print STDERR "No params given to run action - gonna start: '$first_script'\n";
		do($first_script);
	}
}

# TODO: later move app skeleton generation into SDL::Devel (or something like this)
sub generate_sdl_module {
	my ( $path, $name ) = @_;

	#Make the path and directory stuff
	mkdir $path
		or Carp::croak "Cannot make a SDL based module at $path : $!";

	mkdir "$path/lib";
	mkdir "$path/bin";
	mkdir "$path/data";

	open my $FH, ">>$path/bin/sdl_app.pl";

	print $FH "use string;\nuse warnings;\nuse SDL;\n";

	close $FH;

	open $FH, ">>$path/Build.PL";

	print $FH "use strict;\nuse warnings;\nuse Module::Build::SDL;
  my \$builder = Module::Build::SDL->new(
    module_name => '$name',
    dist_version => '1.01',
    dist_abstract => 'Put something in here',
    dist_author => 'developer <developer\@example.com>',
    license => 'perl',
  )->create_build_script();
  ";
}

1;

__END__

=head1 NAME

Module::Build::SDL - Module::Build subclass for building SDL apps/games [not stable yet]

=head1 SYNOPSIS

When creating a new SDL application/game you can create Build.PL like this:

 use Module::Build::SDL;
   
 my $builder = Module::Build::SDL->new(
     module_name   => 'Games::Demo',
     dist_version  => '1.00',
     dist_abstract => 'Demo game based on Module::Build::SDL',
     dist_author   => 'coder@cpan.org',
     license       => 'perl',
     requires      => {
         'SDL'     => 0,
     },
     #+ others Module::Build options
 )->create_build_script();

Once you have created a SDL application/game via Module::Build::SDL as described
above you can use some extra build targets/actions:

=over

=item * you can create a PAR distribution like:

 $ perl ./Build.PL
 $ ./Build
 $ ./Build par

There are some extra parameters related to 'par' action you can pass to Module::Build::SDL->new():

 parinput  => 'bin/scriptname.pl'
 paroutput => 'filename.par.exe',
 parlibs   => [ qw/SDL SDL_main SDL_gfx/ ],  #external libraries (.so/.dll) to be included into PAR
 parmods   => [ qw/Module::A Module::B/ ],   #extra modules to be included into PAR

=item * to run the game from distribution directory you can use:

 $ perl ./Build.PL
 $ ./Build
 $ ./Build run

=item * TODO: maybe some additional actions: parexe, parmsi, deb, rpm

=back

=head1 DESCRIPTION

Module::Build::SDL is a subclass of L<Module::Build|Module::Build> created
to make easy some tasks specific to SDL applications - e.g. packaging SDL
application/game into PAR archive.

=head1 APPLICATION/GAME LAYOUT

Module::Build::SDL expects the following layout in project directory:

 #example: game with the main *.pl script + data files + modules (*.pm)
 Build.PL
 lib/
     Games/
           Demo.pm
 bin/
     game-script.pl
 data/
     whatever_data_files_you_need.jpg

the most simple game should look like:

 #example: simple one-script apllication/game
 Build.PL
 bin/
    game-script.pl

In short - there are 3 expected subdirectories:

=over

=item * B<bin> - one or more perl scripts (*.pl) to start the actual
application/game

=item * B<lib> - application/game specific modules (*.pm) organized
in dir structure in "usual perl manners"

=item * B<data> - directory for storing application data (pictures, 
sounds etc.). This subdirectory is handled as a "ShareDir"
(see L<File::ShareDir|File::ShareDir> for more details)

=item * As the project is (or could be) composed as a standard perl
distribution it also support standard subdirectory B<'t'> (with tests).

=back

=head1 RULES TO FOLLOW

When creating a SDL application/game based on Module::Build::SDL it is
recommended to follow these rules:

=over

=item * Use the name for your game from I<Games::*> namespace; it will make
the later release to CPAN much easier.

=item * Put all data files into B<data> subdirectory and access the B<data>
subdir only via L<File::ShareDir|File::ShareDir> 
(namely by calling L<distdir()|File::ShareDir/dist_dir> function)

=item * TODO: maybe add more

=back

=cut

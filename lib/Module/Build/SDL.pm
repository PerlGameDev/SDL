package Module::Build::SDL;
use strict;
use warnings;
use base 'Module::Build';

# TODO: later move app skeleton generation into SDL::Devel (or something like this)
sub generate_sdl_module {
	my ($path, $name) = @_;

	#Make the path and directory stuff
	mkdir $path or
	Carp::croak "Cannot make a SDL based module at $path : $!";

	mkdir "$path/lib";
	mkdir "$path/bin";
	mkdir "$path/data";

	open my $FH, ">>$path/bin/sdl_app.pl";

	print $FH "use string;\nuse warnings;\nuse SDL;\n";

	close $FH;

	open  $FH, ">>$path/Build.PL";

	print $FH 
	"use strict;\nuse warnings;\nuse Module::Build::SDL;
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
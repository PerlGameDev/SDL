package Module::Build::SDL;
use strict;
use warnings;
use base 'Module::Build';


#Makes the default directory stucture for SDL
#
# $path
#    /lib
#	 /bin
#    /bin/sdl_app.pl
#    /data
# 	 Build.PL
#
sub generate_sdl_module{
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

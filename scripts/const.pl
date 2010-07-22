#!/usr/bin/perl -w

# Since the sdl_const.pl and gl_const.pl scripts with 2.0-beta2 don't seem to
# work at all, this script takes SDL/Constans.pm and OpenGL/Constants.pm (as
# original from 2.0-beta2) and fixes them up, and moves them into ../lib/

# I already did this for 1.20.2, so you need to run this only if you intent
# to rebuild the .pm files.

# See http://Bloodgate.com/perl/sdl/sdl_perl.html

use strict;

##############################################################################

my $sdl = read_file('SDL/Constants.pm');

# remove 'main::' on subs
$sdl =~ s/sub main::([\w]+)/sub $1/g;

# turn on () on subs to make peep optimizer to inline them
#$sdl =~ s/sub ([\w]+)\s+{/sub $1 () {/g;

write_file( '../lib/SDL/Constants.pm', insert_export($sdl) );

undef $sdl;

##############################################################################

my $gl = read_file('OpenGL/Constants.pm');

# remove 'main::' on subs
$gl =~ s/sub main::([\w]+)/sub $1/g;

# turn on () on subs to make peep optimizer to inline them
#$gl =~ s/sub ([\w]+)\s+{/sub $1 () {/g;

write_file(
	'../lib/SDL/OpenGL/Constants.pm',
	insert_export( $gl, grep_constants() )
);

1;

sub read_file {
	my $file = shift;

	print "Reading $file...";
	my $FILE;
	open $FILE, $file or die("Cannot read $file: $!\n");
	local $/; # slurp mode
	my $doc = <$FILE>;
	close $FILE;
	print "done.\n";
	$doc;
}

sub write_file {
	my ( $file, $txt ) = @_;

	print "Writing $file...";
	my $FILE;
	open $FILE, ">$file" or die("Cannot write $file: $!\n");
	print $FILE $txt;
	close $FILE;
	print "done.\n";
}

sub insert_export {
	my $txt = shift;

	my @sub = ();

	# gather all sub names
	$txt =~ s/sub ([\w]+)\s+/push @sub, $1; 'sub ' . $1 . ' '/eg;

	# if we got a second list of names, parse it and include anything that isn't
	# alreay in

	my $add = "";
	if ( ref( $_[0] ) eq 'ARRAY' ) {
		my $const = shift;
		foreach my $c ( sort @$const ) {
			if ( grep ( /^$c->[0]$/, @sub ) == 0 ) {
				print "Adding $c->[0] $c->[1]\n";
				$add .= "sub $c->[0] () { $c->[1] }\n";
				push @sub, $c->[0];
			}
		}
		$add .= "\n";
	}

	# SDL/Constants.pm contains doubles :-( So filter them out.
	my @sorted = sort @sub;
	my $last;
	@sub = ();
	my @doubles;
	foreach my $cur (@sorted) {
		if ( defined $last && $last eq $cur ) {

			# double!
			push @doubles, $last;
		} else {
			push @sub, $last if defined $last;
		}
		$last = $cur;
	}
	foreach my $cur (@doubles) {
		$txt =~ s/\bsub $cur.*//g; # remove
	}

	my $export = "require Exporter;\nuse strict;\n";
	$export .= "use vars qw/\$VERSION \@ISA \@EXPORT/;";
	$export .= "\n\@ISA = qw/Exporter/;\n";

	# this makes Exporter export the symbols from SDL::Constants to whatever
	# package used SDL::Constants (usually SDL::Event.pm)
	my $pack;
	if ( $txt =~ /SDL::Constants/ ) {
		$txt =~ s/SDL::Constants/SDL::Event/g;
		$pack = 'SDL::Event';
	}
	if ( $txt =~ /SDL::OpenGL::Constants/ ) {
		$txt =~ s/SDL::OpenGL::Constants/SDL::OpenGL/g;
		$pack = 'SDL::OpenGL';
	}
	$export .= "\nsub import { $pack\->export_to_level(1, \@_); }\n";

	$export .= "\n\@EXPORT = qw/\n";

	my $line = "\t";
	foreach my $s ( sort @sub ) {
		if ( length($line) + length($s) > 70 ) {
			$export .= "$line\n";
			$line = "\t";
		}
		$line .= "$s ";
	}
	$export .= "$line /;\n";

	# insert Exporter section
	$txt =~ s/sub/$export\n\n$add\nsub/;

	$txt;
}

sub grep_constants {

	# grep all the OpenGL constants from SDL and return them

	my $sdl_gl = read_file('/usr/include/GL/gl.h');

	my @const = ();
	$sdl_gl =~ s/^#define (GL_.*?)\s+(0x[\da-fA-F]+)/push @const,[$1,$2];/egm;

	\@const;
}

END { print "\n"; }

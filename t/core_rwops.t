#!/usr/bin/perl -w
use strict;
use warnings;
use SDL;
use Test::More;
use SDL::RWOps;
my @done = qw/
	new_file
	seek
	close
	/;
can_ok( 'SDL::RWOps', @done );

open FH, '>', '.rwops';
print FH 'rwops';
close FH;

my $file = SDL::RWOps->new_file( '.rwops', 'rw' );
isa_ok( $file, 'SDL::RWOps', '[from_file] returns RWOps' );

#0        SEEK_SET
#1        SEEK_CUR
#2        SEEK_END
my $len = $file->seek( 0, 0 );
is( $len, 0, '[seek] gets seek_end' );
$len = $file->seek( 0, 1 );
is( $len, 0, '[seek] gets seek_start' );
$len = $file->seek( 0, 2 );
is( $len, 5, '[seek] gets seek_cur' );
SKIP:
{
	skip( 'crashing', 1 );
	my $char;
	my $blocks = $file->read( $char, 16, 1 );
	is( $blocks, 5, '[read] got ' . $char );
}
$file->close();
unlink '.rwops';
my @left = qw/
	from_fp
	from_mem
	from_const_mem
	alloc
	free
	tell
	read
	write
	/;

my $why =
	  '[Percentage Completion] '
	. int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
	. "\% implementation. "
	. ( $#done + 1 ) . " / "
	. ( $#done + $#left + 2 );

TODO:
{
	local $TODO = $why;
	fail "Not Implmented $_" foreach (@left)

}
print "$why\n";

done_testing;
sleep(2);

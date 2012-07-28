#!/usr/bin/perl -w
use strict;
use warnings;
use SDL;
use SDL::Version;
use Test::More tests => 8;

my $version = SDL::version();
isa_ok( $version, 'SDL::Version' );
like( $version->major, qr/^\d+$/, 'Compile-time version major is a number' );
like( $version->minor, qr/^\d+$/, 'Compile-time version minor is a number' );
like( $version->patch, qr/^\d+$/, 'Compile-time version patch is a number' );

my $linked_version = SDL::linked_version();
isa_ok( $linked_version, 'SDL::Version' );
like(
	$linked_version->major, qr/^\d+$/,
	'Link-time version major is a number'
);
like(
	$linked_version->minor, qr/^\d+$/,
	'Link-time version minor is a number'
);
like(
	$linked_version->patch, qr/^\d+$/,
	'Link-time version patch is a number'
);

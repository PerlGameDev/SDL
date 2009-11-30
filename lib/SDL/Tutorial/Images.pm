#!/usr/bin/env perl
#
# Images.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig@cpan.org
#

package SDL::Tutorial::Images;

use strict;
use SDL;
use warnings;

my %images;
BEGIN
{
	%images = (
	left => [qw(
		47 49 46 38 37 61 10 00 10 00 E7 00 00 00 00 00 01 01 01 02 02 02 03 03
		03 04 04 04 05 05 05 06 06 06 07 07 07 08 08 08 09 09 09 0A 0A 0A 0B 0B
		0B 0C 0C 0C 0D 0D 0D 0E 0E 0E 0F 0F 0F 10 10 10 11 11 11 12 12 12 13 13
		13 14 14 14 15 15 15 16 16 16 17 17 17 18 18 18 19 19 19 1A 1A 1A 1B 1B
		1B 1C 1C 1C 1D 1D 1D 1E 1E 1E 1F 1F 1F 20 20 20 21 21 21 22 22 22 23 23
		23 24 24 24 25 25 25 26 26 26 27 27 27 28 28 28 29 29 29 2A 2A 2A 2B 2B
		2B 2C 2C 2C 2D 2D 2D 2E 2E 2E 2F 2F 2F 30 30 30 31 31 31 32 32 32 33 33
		33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 38 39 39 39 3A 3A 3A 3B 3B
		3B 3C 3C 3C 3D 3D 3D 3E 3E 3E 3F 3F 3F 40 40 40 41 41 41 42 42 42 43 43
		43 44 44 44 45 45 45 46 46 46 47 47 47 48 48 48 49 49 49 4A 4A 4A 4B 4B
		4B 4C 4C 4C 4D 4D 4D 4E 4E 4E 4F 4F 4F 50 50 50 51 51 51 52 52 52 53 53
		53 54 54 54 55 55 55 56 56 56 57 57 57 58 58 58 59 59 59 5A 5A 5A 5B 5B
		5B 5C 5C 5C 5D 5D 5D 5E 5E 5E 5F 5F 5F 60 60 60 61 61 61 62 62 62 63 63
		63 64 64 64 65 65 65 66 66 66 67 67 67 68 68 68 69 69 69 6A 6A 6A 6B 6B
		6B 6C 6C 6C 6D 6D 6D 6E 6E 6E 6F 6F 6F 70 70 70 71 71 71 72 72 72 73 73
		73 74 74 74 75 75 75 76 76 76 77 77 77 78 78 78 79 79 79 7A 7A 7A 7B 7B
		7B 7C 7C 7C 7D 7D 7D 7E 7E 7E 7F 7F 7F 80 80 80 81 81 81 82 82 82 83 83
		83 84 84 84 85 85 85 86 86 86 87 87 87 88 88 88 89 89 89 8A 8A 8A 8B 8B
		8B 8C 8C 8C 8D 8D 8D 8E 8E 8E 8F 8F 8F 90 90 90 91 91 91 92 92 92 93 93
		93 94 94 94 95 95 95 96 96 96 97 97 97 98 98 98 99 99 99 9A 9A 9A 9B 9B
		9B 9C 9C 9C 9D 9D 9D 9E 9E 9E 9F 9F 9F A0 A0 A0 A1 A1 A1 A2 A2 A2 A3 A3
		A3 A4 A4 A4 A5 A5 A5 A6 A6 A6 A7 A7 A7 A8 A8 A8 A9 A9 A9 AA AA AA AB AB
		AB AC AC AC AD AD AD AE AE AE AF AF AF B0 B0 B0 B1 B1 B1 B2 B2 B2 B3 B3
		B3 B4 B4 B4 B5 B5 B5 B6 B6 B6 B7 B7 B7 B8 B8 B8 B9 B9 B9 BA BA BA BB BB
		BB BC BC BC BD BD BD BE BE BE BF BF BF C0 C0 C0 C1 C1 C1 C2 C2 C2 C3 C3
		C3 C4 C4 C4 C5 C5 C5 C6 C6 C6 C7 C7 C7 C8 C8 C8 C9 C9 C9 CA CA CA CB CB
		CB CC CC CC CD CD CD CE CE CE CF CF CF D0 D0 D0 D1 D1 D1 D2 D2 D2 D3 D3
		D3 D4 D4 D4 D5 D5 D5 D6 D6 D6 D7 D7 D7 D8 D8 D8 D9 D9 D9 DA DA DA DB DB
		DB DC DC DC DD DD DD DE DE DE DF DF DF E0 E0 E0 E1 E1 E1 E2 E2 E2 E3 E3
		E3 E4 E4 E4 E5 E5 E5 E6 E6 E6 E7 E7 E7 E8 E8 E8 E9 E9 E9 EA EA EA EB EB
		EB EC EC EC ED ED ED EE EE EE EF EF EF F0 F0 F0 F1 F1 F1 F2 F2 F2 F3 F3
		F3 F4 F4 F4 F5 F5 F5 F6 F6 F6 F7 F7 F7 F8 F8 F8 F9 F9 F9 FA FA FA FB FB
		FB FC FC FC FD FD FD FE FE FE FF FF FF 2C 00 00 00 00 10 00 10 00 00 08
		36 00 FF 09 1C 48 B0 A0 C1 83 08 13 22 04 C0 10 80 C2 7F 0C 05 46 4C E8
		70 60 C5 85 15 27 52 6C A8 30 E3 45 8C 0D 39 76 FC 38 F2 A1 44 91 1B 4F
		82 24 88 D2 64 C1 80 00 3B
	)],
	center => [qw(
		47 49 46 38 37 61 10 00 10 00 E7 00 00 00 00 00 01 01 01 02 02 02 03 03
		03 04 04 04 05 05 05 06 06 06 07 07 07 08 08 08 09 09 09 0A 0A 0A 0B 0B
		0B 0C 0C 0C 0D 0D 0D 0E 0E 0E 0F 0F 0F 10 10 10 11 11 11 12 12 12 13 13
		13 14 14 14 15 15 15 16 16 16 17 17 17 18 18 18 19 19 19 1A 1A 1A 1B 1B
		1B 1C 1C 1C 1D 1D 1D 1E 1E 1E 1F 1F 1F 20 20 20 21 21 21 22 22 22 23 23
		23 24 24 24 25 25 25 26 26 26 27 27 27 28 28 28 29 29 29 2A 2A 2A 2B 2B
		2B 2C 2C 2C 2D 2D 2D 2E 2E 2E 2F 2F 2F 30 30 30 31 31 31 32 32 32 33 33
		33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 38 39 39 39 3A 3A 3A 3B 3B
		3B 3C 3C 3C 3D 3D 3D 3E 3E 3E 3F 3F 3F 40 40 40 41 41 41 42 42 42 43 43
		43 44 44 44 45 45 45 46 46 46 47 47 47 48 48 48 49 49 49 4A 4A 4A 4B 4B
		4B 4C 4C 4C 4D 4D 4D 4E 4E 4E 4F 4F 4F 50 50 50 51 51 51 52 52 52 53 53
		53 54 54 54 55 55 55 56 56 56 57 57 57 58 58 58 59 59 59 5A 5A 5A 5B 5B
		5B 5C 5C 5C 5D 5D 5D 5E 5E 5E 5F 5F 5F 60 60 60 61 61 61 62 62 62 63 63
		63 64 64 64 65 65 65 66 66 66 67 67 67 68 68 68 69 69 69 6A 6A 6A 6B 6B
		6B 6C 6C 6C 6D 6D 6D 6E 6E 6E 6F 6F 6F 70 70 70 71 71 71 72 72 72 73 73
		73 74 74 74 75 75 75 76 76 76 77 77 77 78 78 78 79 79 79 7A 7A 7A 7B 7B
		7B 7C 7C 7C 7D 7D 7D 7E 7E 7E 7F 7F 7F 80 80 80 81 81 81 82 82 82 83 83
		83 84 84 84 85 85 85 86 86 86 87 87 87 88 88 88 89 89 89 8A 8A 8A 8B 8B
		8B 8C 8C 8C 8D 8D 8D 8E 8E 8E 8F 8F 8F 90 90 90 91 91 91 92 92 92 93 93
		93 94 94 94 95 95 95 96 96 96 97 97 97 98 98 98 99 99 99 9A 9A 9A 9B 9B
		9B 9C 9C 9C 9D 9D 9D 9E 9E 9E 9F 9F 9F A0 A0 A0 A1 A1 A1 A2 A2 A2 A3 A3
		A3 A4 A4 A4 A5 A5 A5 A6 A6 A6 A7 A7 A7 A8 A8 A8 A9 A9 A9 AA AA AA AB AB
		AB AC AC AC AD AD AD AE AE AE AF AF AF B0 B0 B0 B1 B1 B1 B2 B2 B2 B3 B3
		B3 B4 B4 B4 B5 B5 B5 B6 B6 B6 B7 B7 B7 B8 B8 B8 B9 B9 B9 BA BA BA BB BB
		BB BC BC BC BD BD BD BE BE BE BF BF BF C0 C0 C0 C1 C1 C1 C2 C2 C2 C3 C3
		C3 C4 C4 C4 C5 C5 C5 C6 C6 C6 C7 C7 C7 C8 C8 C8 C9 C9 C9 CA CA CA CB CB
		CB CC CC CC CD CD CD CE CE CE CF CF CF D0 D0 D0 D1 D1 D1 D2 D2 D2 D3 D3
		D3 D4 D4 D4 D5 D5 D5 D6 D6 D6 D7 D7 D7 D8 D8 D8 D9 D9 D9 DA DA DA DB DB
		DB DC DC DC DD DD DD DE DE DE DF DF DF E0 E0 E0 E1 E1 E1 E2 E2 E2 E3 E3
		E3 E4 E4 E4 E5 E5 E5 E6 E6 E6 E7 E7 E7 E8 E8 E8 E9 E9 E9 EA EA EA EB EB
		EB EC EC EC ED ED ED EE EE EE EF EF EF F0 F0 F0 F1 F1 F1 F2 F2 F2 F3 F3
		F3 F4 F4 F4 F5 F5 F5 F6 F6 F6 F7 F7 F7 F8 F8 F8 F9 F9 F9 FA FA FA FB FB
		FB FC FC FC FD FD FD FE FE FE FF FF FF 2C 00 00 00 00 10 00 10 00 00 08
		36 00 FF 09 1C 48 B0 A0 C1 83 08 13 26 04 C0 10 80 C2 7F 0C 05 46 5C 48
		D0 E1 42 8B 13 2F 66 54 B8 F1 60 C3 8F 16 2F 3E 1C D8 11 E1 C7 87 13 4B
		4A DC D8 70 E4 C1 80 00 3B
	)],
	right => [qw(
		47 49 46 38 37 61 10 00 10 00 E7 00 00 00 00 00 01 01 01 02 02 02 03 03
		03 04 04 04 05 05 05 06 06 06 07 07 07 08 08 08 09 09 09 0A 0A 0A 0B 0B
		0B 0C 0C 0C 0D 0D 0D 0E 0E 0E 0F 0F 0F 10 10 10 11 11 11 12 12 12 13 13
		13 14 14 14 15 15 15 16 16 16 17 17 17 18 18 18 19 19 19 1A 1A 1A 1B 1B
		1B 1C 1C 1C 1D 1D 1D 1E 1E 1E 1F 1F 1F 20 20 20 21 21 21 22 22 22 23 23
		23 24 24 24 25 25 25 26 26 26 27 27 27 28 28 28 29 29 29 2A 2A 2A 2B 2B
		2B 2C 2C 2C 2D 2D 2D 2E 2E 2E 2F 2F 2F 30 30 30 31 31 31 32 32 32 33 33
		33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 38 39 39 39 3A 3A 3A 3B 3B
		3B 3C 3C 3C 3D 3D 3D 3E 3E 3E 3F 3F 3F 40 40 40 41 41 41 42 42 42 43 43
		43 44 44 44 45 45 45 46 46 46 47 47 47 48 48 48 49 49 49 4A 4A 4A 4B 4B
		4B 4C 4C 4C 4D 4D 4D 4E 4E 4E 4F 4F 4F 50 50 50 51 51 51 52 52 52 53 53
		53 54 54 54 55 55 55 56 56 56 57 57 57 58 58 58 59 59 59 5A 5A 5A 5B 5B
		5B 5C 5C 5C 5D 5D 5D 5E 5E 5E 5F 5F 5F 60 60 60 61 61 61 62 62 62 63 63
		63 64 64 64 65 65 65 66 66 66 67 67 67 68 68 68 69 69 69 6A 6A 6A 6B 6B
		6B 6C 6C 6C 6D 6D 6D 6E 6E 6E 6F 6F 6F 70 70 70 71 71 71 72 72 72 73 73
		73 74 74 74 75 75 75 76 76 76 77 77 77 78 78 78 79 79 79 7A 7A 7A 7B 7B
		7B 7C 7C 7C 7D 7D 7D 7E 7E 7E 7F 7F 7F 80 80 80 81 81 81 82 82 82 83 83
		83 84 84 84 85 85 85 86 86 86 87 87 87 88 88 88 89 89 89 8A 8A 8A 8B 8B
		8B 8C 8C 8C 8D 8D 8D 8E 8E 8E 8F 8F 8F 90 90 90 91 91 91 92 92 92 93 93
		93 94 94 94 95 95 95 96 96 96 97 97 97 98 98 98 99 99 99 9A 9A 9A 9B 9B
		9B 9C 9C 9C 9D 9D 9D 9E 9E 9E 9F 9F 9F A0 A0 A0 A1 A1 A1 A2 A2 A2 A3 A3
		A3 A4 A4 A4 A5 A5 A5 A6 A6 A6 A7 A7 A7 A8 A8 A8 A9 A9 A9 AA AA AA AB AB
		AB AC AC AC AD AD AD AE AE AE AF AF AF B0 B0 B0 B1 B1 B1 B2 B2 B2 B3 B3
		B3 B4 B4 B4 B5 B5 B5 B6 B6 B6 B7 B7 B7 B8 B8 B8 B9 B9 B9 BA BA BA BB BB
		BB BC BC BC BD BD BD BE BE BE BF BF BF C0 C0 C0 C1 C1 C1 C2 C2 C2 C3 C3
		C3 C4 C4 C4 C5 C5 C5 C6 C6 C6 C7 C7 C7 C8 C8 C8 C9 C9 C9 CA CA CA CB CB
		CB CC CC CC CD CD CD CE CE CE CF CF CF D0 D0 D0 D1 D1 D1 D2 D2 D2 D3 D3
		D3 D4 D4 D4 D5 D5 D5 D6 D6 D6 D7 D7 D7 D8 D8 D8 D9 D9 D9 DA DA DA DB DB
		DB DC DC DC DD DD DD DE DE DE DF DF DF E0 E0 E0 E1 E1 E1 E2 E2 E2 E3 E3
		E3 E4 E4 E4 E5 E5 E5 E6 E6 E6 E7 E7 E7 E8 E8 E8 E9 E9 E9 EA EA EA EB EB
		EB EC EC EC ED ED ED EE EE EE EF EF EF F0 F0 F0 F1 F1 F1 F2 F2 F2 F3 F3
		F3 F4 F4 F4 F5 F5 F5 F6 F6 F6 F7 F7 F7 F8 F8 F8 F9 F9 F9 FA FA FA FB FB
		FB FC FC FC FD FD FD FE FE FE FF FF FF 2C 00 00 00 00 10 00 10 00 00 08
		3A 00 FF 09 1C 48 B0 A0 C1 83 08 13 2A 04 C0 10 80 C2 7F 0C 05 46 4C E8
		70 60 45 84 13 27 52 6C F8 50 62 C5 8B 05 1B 8A 04 79 50 E3 43 93 1B 51
		1A CC 48 D2 A2 49 8E 1D 0B 06 04 00 3B
	)],
);
}

use Pod::ToDemo sub
{
	(undef, my $filename) = @_;
	(my $imagebase        = $filename) =~ s/\.\w+$//;
	my @img_files         = map { $imagebase . "_$_.gif" }
		qw( left center right );
	my $demo_source       = <<'END_HERE';
package SDL::Tutorial::Images::Walker;

sub new
{
	my ($class, @images) = @_;
	my @frames           = map { SDL::Surface->new( -name => $_ ) } @images;
	my $frame_rect       = SDL::Rect->new(
		-height => $frames[0]->height(),
		-width  => $frames[0]->width(),
		-x      => 0,
		-y      => 0,
	);
	my $self             = 
	{
		frames      => \@frames,
		frame_rect  => $frame_rect,
	};
	bless $self, $class;
}

sub frames
{
	my $self        = shift;
	$self->{frames} = shift if @_;
	$self->{frames};
}

sub frame_rect
{
	my $self            = shift;
	$self->{frame_rect} = shift if @_;
	$self->{frame_rect};
}

sub next_frame
{
	my $self   = shift;
	my $frames = $self->frames();
	my $frame  = shift @$frames;

	push @$frames, $frame;
	$self->frames( $frames );

	return $frame;
}

package main;

use strict;

use SDL;
use SDL::App;
use SDL::Surface;
use SDL::Color;

# change these values as necessary
my $title                                = 'My SDL Animation';
my ($width,      $height,      $depth)   = (  640,  480,   16 );
my ($bg_r,       $bg_g,        $bg_b)    = ( 0xff, 0xff, 0xff );
my ($start_x,    $end_x)                 = (   20,  600       );
my $sleep_msec                           = 0.05;

my $app = SDL::App->new(
	-width  => $width,
	-height => $height,
	-depth  => $depth,
);

my $bg_color = SDL::Color->new(
	-r => $bg_r,
	-g => $bg_g,
	-b => $bg_b,
);

my $background = SDL::Rect->new(
	-width  => $width,
	-height => $height,
);

my $pos = SDL::Rect->new(
	-width  => 16,
	-height => 16,
	-x      => 0,
	-y      => 240,
);

my $walker = SDL::Tutorial::Images::Walker->new(qw(
END_HERE

$demo_source .= join( ' ', @img_files ) . "));" . <<'END_HERE';

for my $x ( $start_x .. $end_x )
{
	draw_background( $app, $background, $bg_color );
	$pos->x( $x );
	draw_walker( $walker, $app, $pos );
	$app->update( $background );
	select( undef, undef, undef, $sleep_msec );
}

# you'll want to remove this
sleep 2;

sub draw_background
{
	my ($app, $background, $bg_color) = @_;
	$app->fill( $background, $bg_color );
}

sub draw_walker
{
	my ($walker, $app, $pos) = @_;
	my $frame                = $walker->next_frame();
	my $frame_rect           = $walker->frame_rect();
	$frame->blit( $frame_rect, $app, $pos );
}
END_HERE

	Pod::ToDemo::write_demo( $filename, "#$^X\n$demo_source" );
	write_files( $imagebase );
};
		
sub write_files
{
	my $imagebase = shift;

	for my $image (qw( left center right ))
	{
		my $file = join('', map { chr( hex( $_ ) ) } @{ $images{ $image } });
		write_file( $imagebase . "_$image" . '.gif', $file );
	}
}

sub write_file
{
    my ($file, $contents) = @_;

	die "Cowardly refusing to overwrite '$file'\n" if -e $file;
	open my $out, '>', $file or die "Cannot write '$file': $!\n";
	binmode $out;
	print $out $contents;
}

__END__

=head1 NAME

SDL::Tutorial::Images

=head1 SYNOPSIS

	# to read this tutorial
	$ perldoc SDL::Tutorial::Images

	# to create a demo animation program based on this tutorial
	$ perl -MSDL::Tutorial::Images=sdl_images.pl -e 1

=head1 ANIMATING IMAGES

Since you're already familiar with the concepts behind animation, it's time to
learn how to work with images.  As usual, the important point is that computer animation is just I<simulating> motion by painting several slightly different frames to the screen every second.

There are two ways to vary an image on screen.  One is to change its
coordinates so it's at a slightly different position.  This is very easy to do;
it's just like animating a rectangle.  The other way is to change the image
itself so it's slightly different.  This is a little more difficult, as you'll
need to draw the alternate image beforehand somehow.

=head2 Loading Images

As usual, start with an L<SDL::App> object representing the image window.  Then
preload the image file.  This is easy; just pass the C<name> parameter to the
L<SDL::Surface> constructor:

	use SDL::Surface;

	my $frame = SDL::Surface->new( -name => 'frame1.png' );

B<Note:> you'll need to have compiled SDL Perl (and probably SDL) to support
JPEG and PNG files for this to work.

That's it; now you have an SDL::Surface object containing the image.  You can
use the C<height()>, C<width()>, and C<bpp()> methods to retrieve its height,
width, and bits per pixel, if you need them.

=head2 Displaying Images

Drawing an image onto the screen requires blitting it from one surface to
another.  (Remember, "blitting" means copying bits in memory.)  The C<blit()>
method of SDL::Surface objects comes in handy.  Its arguments are a little odd,
though.  Assuming C<$app> is the SDL::App object, as usual:

	use SDL::Rect;

	my $frame_rect = SDL::Rect->new(
		-height => $frame->height(),
		-width  => $frame->width(),
		-x      => 0,
		-y      => 0,
	);

	my $dest_rect  = SDL::Rect->new(
		-height => $frame->height(),
		-width  => $frame->width(),
		-x      => 0,
		-y      => 0,
	);

	$frame->blit( $frame_rect, $app, $dest_rect );
	$app->update( $dest_rect );

Here we have two L<SDL::Rect> objects which represent rectangular regions of a
Surface.  C<$frame_rect> represents the entire area of C<$frame>, while
C<$dest_rect> represents the area of the main window in which to blit the
frame.  This may be clearer with more descriptive variable names:

	$source_surface->blit(
		$area_of_source_to_blit,
		$destination_surface,
		$destination_area
	);

As usual, call C<update()> on C<$app> to see the change.

Requiring the source and destination Rect objects may seem tedious in this
simple example, but it's highly useful for copying only part of surface to part
of another.  For example, animating this image is a matter of changing the C<x>
and C<y> coordinates of C<$dest_rect>:

	for my $x ( 1 .. 100 )
	{
		$dest_rect->x( $x );
		$frame->blit( $frame_rect, $app, $dest_rect );
		$app->update( $dest_rect );
	}

Of course, you'll have to redraw all or part of the screen to avoid artifacts,
as discussed in the previous tutorial.

=head2 Multi-Image Animation

That covers moving a single image around the screen.  What if you want
something more?  For example, what if you want to animate a stick figure
walking?

You'll need several frames, just as in a flip-book.  Each frame should be slightly different than the one before it.  It's probably handy to encapsulate all of this in a C<Walker> class:

	package SDL::Tutorial::Images::Walker;

	use SDL::Surface;

	sub new
	{
		my ($class, @images) = @_;
		my $self = [ map { SDL::Surface->new( -name => $_ ) } @images ];

		bless $self, $class;
	}

	sub next_frame
	{
		my $self  = shift;
		my $frame = shift @$self;

		push @$self, $frame;
		return $frame;
	}

To use this class, instantiate an object:

	my $walker = SDL::Tutorial::Images::Walker->new( 'frame1.png', 'frame2.png', 'frame3.png' );

Then call C<next_frame()> within the loop:

	for my $x ( 1 .. 100 )
	{
		my $frame = $walker->next_frame();

		$dest_rect->x( $x );
		$frame->blit( $frame_rect, $app, $dest_rect );
		$app->update( $dest_rect );
	}

Again, the rest of the frame drawing is missing from this example so as not to
distract from this technique.  You'll probably want to abstract the undrawing
and redrawing into a separate subroutine so you don't have to worry about it
every time.

It'd be easy to make C<next_frame()> much smarter, selecting an image
appropriate to the direction of travel, using a bored animation when the
character is no longer moving, or adding other characteristics to the
character.  As you can see, the hard part of this technique is generating the
images beforehand.  That can add up to a tremendous amount of art and that's
one reason for the popularity of 3D models... but that's another tutorial much
further down the road.

More importantly, it's time to discuss how to make these animations run more
smoothly.  More on that next time.

=head1 SEE ALSO

=over 4

=item L<SDL::Tutorial>

basic SDL tutorial

=item L<SDL::Tutorial::Animation>

non-image animation

=back

=head1 AUTHOR

chromatic, E<lt>chromatic@wgz.orgE<gt>

Written for and maintained by the Perl SDL project, L<http://sdl.perl.org/>.

=head1 BUGS

No known bugs.

=head1 COPYRIGHT

Copyright (c) 2004, chromatic.  All rights reserved.  This module is
distributed under the same terms as Perl itself, in the hope that it is useful
but certainly under no guarantee.

package SDL::Video;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::Video;

1;

__END__

=pod

=head1 NAME

SDL::Video - Bindings to the video category in SDL API

=head1 SYNOPSIS

This module is not an object. Please read the 

=head1 DESCRIPTION



=head1 METHODS

=head2 get_video_surface

=head2 get_video_info


=head1 SEE ALSO

=head2 Category Objects

L<SDL::Surface>, L<SDL::Overlay>, L<SDL::Color>,
L<SDL::Rect>, L<SDL::Palette>, L<SDL::PixelFormat>, 
L<SDL::VideoInfo>

=cut

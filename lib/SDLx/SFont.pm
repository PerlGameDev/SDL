package SDLx::SFont;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::TTF';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::TTF'} };

push( @EXPORT, 'SDL_TEXTWIDTH' );

our %EXPORT_TAGS = (
	all     => \@EXPORT,
	hinting   => $SDL::Constants::EXPORT_TAGS{'SDL::TTF/hinting'},
	style => $SDL::Constants::EXPORT_TAGS{'SDL::TTF/style'},
);

sub SDL_TEXTWIDTH {
	return SDLx::SFont::TextWidth(join('',@_));
}

sub print_text{ #print is a horrible name for this
	my ($surf, $x, $y, @text) = @_;
	SDLx::SFont::print_string( $surf, $x,$y,join('', @text));
}


bootstrap SDLx::SFont;

1;

#################### main pod documentation begin ###################


=head1 NAME

SDLx::SFont - Extensions for printing text onto surfaces 

=head1 SYNOPSIS


  use SDLx::SFont;
  use SDLx::App;

   #Make a surface
   #Select a font
   my $d = SDL::App->new( -title => 'app', -width => 200, -height => 200, -depth => 32 );

   my $font = SDLx::SFont->new('t/font.png');
  
   #print using $font
   
   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );

   my $font2 = SDLx::SFont->new('t/font2.png');

   #print using font2

   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );

   $font->use();

   #print using $font
   
   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );




   #that is it folks ..

=head1 DESCRIPTION

a simpler print function for old SDL::SFont dependency on Frozen-Bubble and Pangzero.

Might actually be a usefull module some day ...

=head1 USAGE

see synopsis

=head1 BUGS

none

=head1 SUPPORT

#sdl irc.perl.org

=head1 AUTHOR

    Kartik Thakore
    CPAN ID: KTHAKORE
    ---
    kthakore@cpan.org
    http://sdl.perl.org

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1), SDL(2).

=cut

#################### main pod documentation end ###################


1;
# The preceding line will help the module return a true value

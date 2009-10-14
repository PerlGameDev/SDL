#!/usr/bin/env perl
#
# TTFont.pm
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

package SDL::TTFont;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Surface;

use vars qw/ @ISA /;

@ISA = qw(SDL::Surface);

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options;
	(%options) = @_;
	$self->{-mode} = $options{-mode} 	|| $options{-m}	 || SDL::TEXT_SHADED();
	$self->{-name} = $options{-name} 	|| $options{-n};
	$self->{-size} = $options{-size} 	|| $options{-s};
	$self->{-fg} = $options{-foreground} 	|| $options{-fg} || $SDL::Color::black;
	$self->{-bg} = $options{-background}	|| $options{-bg} || $SDL::Color::white;

	croak "SDL::TTFont::new requires a -name\n"
		unless ($$self{-name});

	croak "SDL::TTFont::new requires a -size\n"
		unless ($$self{-size});

	$self->{-font} = SDL::TTFOpenFont($self->{-name},$self->{-size});

	croak "Could not open font $$self{-name}, ", SDL::GetError(), "\n"
		unless ($self->{-font});

	bless $self,$class;
	return $self;	
}

sub DESTROY {
	my $self = shift;
	SDL::FreeSurface($self->{-surface}) if (defined ($self->{-surface}));
	SDL::TTFCloseFont($self->{-font}) if (defined ($self->{-font}));
}

sub print {
	my ($self,$surface,$x,$y,@text) = @_;

	croak "Print requies an SDL::Surface"
		unless( ref($surface) && $surface->isa("SDL::Surface") );

	SDL::FreeSurface($self->{-surface}) if ($$self{-surface});

	$$self{-surface} = SDL::TTFPutString($$self{-font},$$self{-mode},
		$$surface,$x,$y,$self->{-fg},$self->{-bg},join("",@text));

	croak "Could not print \"", join("",@text), "\" to surface, ",
		SDL::GetError(), "\n" unless ($$self{-surface});
}

sub width {
        my ($self,@text) = @_;
        my $aref = SDL::TTFSizeText($$self{-font},join(" ",@text));
	$$aref[0];
}

sub height {
        my ($self) = @_;
        SDL::TTFFontHeight($$self{-font});
}

sub ascent {
        my ($self) = @_;
        SDL::TTFFontAscent($$self{-font});
}

sub descent {
        my ($self) = @_;
        SDL::TTFFontDescent($$self{-font});
}

sub normal {
	my ($self) = @_;
	SDL::TTFSetFontStyle($$self{-font},SDL::TTF_STYLE_NORMAL());
}

sub bold {
	my ($self) = @_;
	SDL::TTFSetFontStyle($$self{-font},SDL::TTF_STYLE_BOLD());
}

sub italic {
	my ($self) = @_;
	SDL::TTFSetFontStyle($$self{-font},SDL::TTF_STYLE_ITALIC());

}

sub underline {
	my ($self) = @_;
	SDL::TTFSetFontStyle($$self{-font},SDL::TTF_STYLE_UNDERLINE());
}

sub text_shaded {
	my ($self) = @_;
	$$self{-mode} = SDL::TEXT_SHADED();
}

sub text_solid {
	my ($self) = @_;
	$$self{-mode} = SDL::TEXT_SOLID();
}

sub text_blended {
	my ($self) = @_;
	$$self{-mode} = SDL::TEXT_BLENDED();
}

sub utf8_shaded {
	my ($self) = @_;
	$$self{-mode} = SDL::UTF8_SHADED();
}

sub utf8_solid {
	my ($self) = @_;
	$$self{-mode} = SDL::UTF8_SOLID();
}

sub utf8_blended {
	my ($self) = @_;
	$$self{-mode} = SDL::UTF8_BLENDED();
}

sub unicode_shaded {
	my ($self) = @_;
	$$self{-mode} = SDL::UNICODE_SHADED();
}

sub unicode_solid {
	my ($self) = @_;
	$$self{-mode} = SDL::UNICODE_SOLID();
}

sub unicode_blended {
	my ($self) = @_;
	$$self{-mode} = SDL::UNICODE_BLENDED();
}

croak "Could not initialize True Type Fonts\n"
	if ( SDL::TTFInit() < 0);

1;

__END__;

=head1 NAME

SDL::TTFont - a SDL perl extension

=head1 SYNOPSIS

  $font = SDL::TTFont->new( -name => "Utopia.ttf", -size => 18 );
	
=head1 DESCRIPTION

L<< SDL::TTFont >> is a module for applying true type fonts to L<< SDL::Surface >>.

=head1 METHODS

=head2 new

Instanciates a new font surface. It accepts the following parameters:

=head3 -name

=head3 -n

The font filename (possibly with proper path) to be used. B<< This options is mandatory >>.

=head3 -size

=head3 -s

The font size (height, in pixels) to be used. B<< This option is mandatory >>.

=head3 -foreground

=head3 -fg

Foreground color for the font surface (i.e. the actual font color). It expects a 
SDL::Color value. If omitted, black is used as font color.

=head3 -background

=head3 -bg

Background color for the font surface (i.e. the font background color). It expects 
a SDL::Color value. If omitted , white is used for the background.

=head3 -mode

=head3 -m

Font mode. If omitted, SDL::TEXT_SHADED is used. Note that this class provides 
human friendly accessors for setting different modes, so you should probably use 
them instead. See below for further details.

=head2 Text Modes

The SDL::TTFont accepts three different types (shaded, solid, blended) for 
three different encodings (text, utf8, unicode).

  $font->text_shaded;       # sets mode to SDL::TEXT_SHADED
  $font->text_solid;        # sets mode to SDL::TEXT_SOLID
  $font->text_blended;      # sets mode to SDL::TEXT_BLENDED
  
  $font->utf8_shaded;       # sets mode to SDL::UTF8_SHADED
  $font->utf8_solid;        # sets mode to SDL::UTF8_SOLID
  $font->utf8_blended;      # sets mode to SDL::UTF8_BLENDED
  
  $font->unicode_shaded;    # sets mode to SDL::UNICODE_SHADED
  $font->unicode_solid;     # sets mode to SDL::UNICODE_SOLID
  $font->unicode_blended;   # sets mode to SDL::UNICODE_BLENDED

=head2 Text Style

You may also smoothly change your font style by calling any of the following 
methods:

  $font->normal;       # resets font styling, making text "normal"
  $font->bold;         # sets bold style for font
  $font->italic;       # sets italic style for font
  $font->underline;    # sets underline style for font


=head2 Ascent/Descent values

Ascent is the number of pixels from the font baseline to the top of the font, while 
descent is the number of pixels from the font baseline to the bottom of the font.

  $font->ascent;      # height in pixels of the font ascent
  $font->descent;     # height in pixels of the font descent

=head2 height

  my $height = $font->height;
  
Returns the height, in pixels, of the actual rendered text. This is the 
average size for each glyph in the font.

=head2 width(@text)

  my $width = $font->width("Choose your destiny");

Returns the dimensions needed to render the text. This can be used to help 
determine the positioning needed for text before it is rendered. It can also 
be used for wordwrapping and other layout effects.

Be aware that most fonts - notably, non-monospaced ("ms") ones - use kerning 
which adjusts the widths for specific letter pairs. For example, the width 
for "ae" will not always match the width for "a" + "e".

=head2 print ($surface, $top, $left, @text)

Directly draws text to an existing surface. Receives the target L<< SDL::Surface >> 
object and the relative top (y) and left (x) coordinates to put the text in. 
The last parameter may be a string or an array or strings with the text to be 
written.


=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl>, L<SDL>, L<< SDL::Surface >>

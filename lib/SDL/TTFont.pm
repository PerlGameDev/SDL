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
	my $self  = {};
	my %options;
	(%options) = @_;
	$self->{-mode} = $options{-mode}       || $options{-m} || SDL::TEXT_SHADED();
	$self->{-name} = $options{-name}       || $options{-n};
	$self->{-size} = $options{-size}       || $options{-s};
	$self->{-fg}   = $options{-foreground} || $options{-fg} || $SDL::Color::black;
	$self->{-bg}   = $options{-background} || $options{-bg} || $SDL::Color::white;

	Carp::confess "SDL::TTFont::new requires a -name\n"
		unless ( $$self{-name} );

	Carp::confess "SDL::TTFont::new requires a -size\n"
		unless ( $$self{-size} );

	$self->{-font} = SDL::TTFOpenFont( $self->{-name}, $self->{-size} );

	Carp::confess "Could not open font $$self{-name}, ", SDL::GetError(), "\n"
		unless ( $self->{-font} );

	bless $self, $class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::FreeSurface( $self->{-surface} ) if ( defined( $self->{-surface} ) );
	SDL::TTFCloseFont( $self->{-font} )   if ( defined( $self->{-font} ) );
}

sub print {
	my ( $self, $surface, $x, $y, @text ) = @_;

	Carp::confess "Print requies an SDL::Surface"
		unless ( ref($surface) && $surface->isa("SDL::Surface") );

	SDL::FreeSurface( $self->{-surface} ) if ( $$self{-surface} );

	$$self{-surface} = SDL::TTFPutString(
		$$self{-font}, $$self{-mode}, $$surface, $x, $y,
		$self->{-fg},  $self->{-bg},  join( "",  @text )
	);

	Carp::confess "Could not print \"", join( "", @text ), "\" to surface, ", SDL::GetError(), "\n"
		unless ( $$self{-surface} );
}

sub width {
	my ( $self, @text ) = @_;
	my $aref = SDL::TTFSizeText( $$self{-font}, join( " ", @text ) );
	$$aref[0];
}

sub height {
	my ($self) = @_;
	SDL::TTFFontHeight( $$self{-font} );
}

sub ascent {
	my ($self) = @_;
	SDL::TTFFontAscent( $$self{-font} );
}

sub descent {
	my ($self) = @_;
	SDL::TTFFontDescent( $$self{-font} );
}

sub normal {
	my ($self) = @_;
	SDL::TTFSetFontStyle( $$self{-font}, SDL::TTF_STYLE_NORMAL() );
}

sub bold {
	my ($self) = @_;
	SDL::TTFSetFontStyle( $$self{-font}, SDL::TTF_STYLE_BOLD() );
}

sub italic {
	my ($self) = @_;
	SDL::TTFSetFontStyle( $$self{-font}, SDL::TTF_STYLE_ITALIC() );

}

sub underline {
	my ($self) = @_;
	SDL::TTFSetFontStyle( $$self{-font}, SDL::TTF_STYLE_UNDERLINE() );
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

Carp::confess "Could not initialize True Type Fonts\n"
	if ( SDL::TTFInit() < 0 );

1;

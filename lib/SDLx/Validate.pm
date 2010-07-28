#Interal Module to validate SDLx types
package SDLx::Validate;
use strict;
use warnings;
use Carp;

sub surfaces
{
    my $surface = shift;
    
        if ($surface->isa('SDL::Surface'))
        {
            return $surface;
        }
        elsif( $surface->isa('SDLx::Surface' ))
        {
            require SDLx::Surface;
            return $surface->surface();
        }
        else
        {
          Carp::croak 'SDLx::Surface or SDL::Surface for surface required';
        }

}

sub sdl_surface
{
    my $surface = shift;
    Carp::croak 'SDL::Surface for surface required'
    unless $surface->isa('SDL::Surface');

}


sub rects
{
    my $src_rect = shift;
    if ( ref($src_rect) eq 'ARRAY' ) 
    {
        require SDL::Rect;
        return SDL::Rect->new(@{$src_rect});
    }
    elsif ( $src_rect->isa('SDL::Rect') )
    {
        return $src_rect;
    }
    else
    {
        Carp::croak 'Array ref or SDL::Rect for source rect required.'
    }

}

1;


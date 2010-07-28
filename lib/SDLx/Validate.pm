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
    require SDL::Rect;

    my ($src_rect, $rect_array_ref) = @_; #passed to cover undef

    if ( ref($rect_array_ref) eq 'ARRAY' && !defined($src_rect) )
    {
        return SDL::Rect->new(@{$rect_array_ref});
    }
    elsif ( ref($src_rect) eq 'ARRAY' ) 
    {
        return SDL::Rect->new(@{$src_rect});
    }
    elsif ( $src_rect->isa('SDL::Rect') )
    {
        return $src_rect;
    }
    else
    {
            Carp::croak 'Array ref or SDL::Rect for source rect required.';
    }

}

1;


#
#	SDL::GraphicTool   -	zooming and rotating graphic tool
#
#	Copyright (C) 2002 Russell E. Valentine
#	Copyright (C) 2002 David J. Goehrig

package SDL::Tool::Graphic;

use SDL;
use SDL::Config;
require SDL::Surface;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	$self = {};
	bless $self, $class;
	$self;
}


sub DESTROY {
	# nothing to do
}


sub zoom {
	my ( $self, $surface, $zoomx, $zoomy, $smooth) = @_;
	die "SDL::Tool::Graphic::zoom requires an SDL::Surface\n"
		unless ( ref($surface) && $surface->isa('SDL::Surface'));
	my $tmp = $$surface;
	$$surface = SDL::GFXZoom($$surface, $zoomx, $zoomy, $smooth);
	SDL::FreeSurface($tmp);
	$surface;
}

sub rotoZoom {
	my ( $self, $surface, $angle, $zoom, $smooth) = @_;
	die "SDL::Tool::Graphic::rotoZoom requires an SDL::Surface\n"
		unless ( ref($surface) && $surface->isa('SDL::Surface'));
	my $tmp = $$surface;
	$$surface = SDL::GFXRotoZoom($$surface, $angle, $zoom, $smooth);
	SDL::FreeSurface($tmp);
	$surface;
}

sub grayScale {
	my ( $self, $surface ) = @_;
	if($surface->isa('SDL::Surface')) {
		$workingSurface = $$surface;
	} else {
		$workingSurface = $surface;
	}
	my $color;
	my $width = SDL::SurfaceW($workingSurface);
	my $height = SDL::SurfaceH($workingSurface);
	for(my $x = 0; $x < $width; $x++){
		for(my $y = 0; $y < $height; $y++){
			my $origValue = SDL::SurfacePixel($workingSurface, $x, $y);
			my $newValue = int(0.3*SDL::ColorR($origValue) + 0.59 * SDL::ColorG($origValue) + 0.11*SDL::ColorB($origValue));
			SDL::SurfacePixel($workingSurface, $x, $y, SDL::NewColor($newValue, $newValue, $newValue));
		}
	}
 
	if($surface->isa('SDL::Surface')) {
       		$surface = \$workingSurface;
	} else {
		$surface = $workingSurface;
	}
}
 
sub invertColor {
	my ( $self, $surface ) = @_;
	if($surface->isa('SDL::Surface')) {
		$workingSurface = $$surface;
	} else {
		$workingSurface = $surface;
	}
	my $width = SDL::SurfaceW($workingSurface);
	my $height = SDL::SurfaceH($workingSurface);
	for(my $x = 0; $x < $width; $x++){
		for(my $y = 0; $y < $height; $y++){
			my $origValue = SDL::SurfacePixel($workingSurface, $x, $y);
			my $newValue = int(0.3*SDL::ColorR($origValue) + 0.59 * SDL::ColorG($origValue) + 0.11*SDL::ColorB($origValue));
			SDL::SurfacePixel($workingSurface, $x, $y, SDL::NewColor(255-SDL::ColorR($origValue), 255 - SDL::ColorG($origValue), 255 - SDL::ColorB($origValue)));
		}
	}

	if($surface->isa('SDL::Surface')) {
		$$surface = $workingSurface;
	} else {
		$surface = $workingSurface;
	}
}

die "SDL::Tool::Graphic requires SDL_gfx support\n"
	unless SDL::Config->has('SDL_gfx');
 

1;

__END__;

=pod



=head1 NAME

SDL::Tool::Graphic

=head1 DESCRIPTION

L<SDL::Tool::Graphic> is a module for zooming and rotating L<SDL::Surface> objects.

=head1 METHODS

=head2 zoom ( surface, xzoom, yzoom, smooth )

C<SDL::Tool::Graphic::zoom> scales a L<SDL::Surface> along the two axis independently.

=head2 rotoZoom ( surface, angle, zoom, smooth )

C<SDL::Tool::Graphic::rotoZoom> rotates and fixed axis zooms a L<SDL::Surface>.

=head2 grayScale ( surface )
 
C<SDL::Tool::Graphic::grayScale> rotates and fixed axis zooms a L<SDL::Surface>.

=head2 invertColor ( surface )

C<SDL::Tool::Graphic::invertColor> inverts the color of a <SDL::Surface>.


=head1 AUTHOR

Russell E. Valentine

=head1 SEE ALSO

L<perl> L<SDL::Surface>

=cut

use strict;
use warnings;
use Data::Dumper;
use File::Spec;

my $head_loc = `sdl-config --cflags`;
$head_loc = ( split ' ', $head_loc )[0];
$head_loc =~ s/-I//;

# This should be a config file that is updated regularly
my %mod_headers = (
    SDL_gfxPrimitives => 'SDL::GFX::Primitives',
    SDL_rotozoom      => 'SDL::GFX::Rotozoom',
    SDL_framerate     => 'SDL::GFX::Framerate',
    SDL_imageFilter   => 'SDL::GFX::ImageFilter',
    SDL_gfxBlitFunc   => 'SDL::GFX::BlitFunc',
);

#check to see we have a different path set for SDL_gfx
#

if ( $ENV{SDL_GFX_LOC} && -d $ENV{SDL_GFX_LOC} ) {
    warn 'Using user defined location for SDL_GFX and not ' . $head_loc;
    $head_loc = $ENV{SDL_GFX_LOC};
}

while (my ($header, $module) = each(%mod_headers )) {

    my $file = File::Spec->catfile( $head_loc, $header.'.h' );

    warn " Creating Config for: $file at $module ::Config \n";
    
    my $config = { header => $header.'.h', file => $file, module => $module };   
    

    my $FH;
    open $FH, '<' . $file
    or warn "Cannot find $file please set \$ENV{SDL_GFX_LOC} to point to a different location  : $!";

    if (!$FH){$config->{exist} = -1  ; next }

    my @methods = ();

    grep { $_ =~ /^(\s+|)(\S+) (\S+) (\*|)(\S+)(\()/; push ( @methods, $5) if $5 }
      <$FH>;
      
      $config->{methods} = \@methods;

    close $FH;
    
    warn Dumper $config;

}

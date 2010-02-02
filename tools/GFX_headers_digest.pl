use strict;
use warnings;
use File::Spec;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;


my @headers = qw/ SDL_gfxPrimitives.h SDL_rotozoom.h SDL_framerate.h SDL_imageFilter.h SDL_gfxBlitFunc.h /;

#check to see we have a different path set for SDL_gfx
#

if ( $ENV{SDL_GFX_LOC} && -d $ENV{SDL_GFX_LOC})
{
	warn 'Using user defined location for SDL_GFX and not '.$head_loc;
	$head_loc = $ENV{SDL_GFX_LOC};
}


foreach my $header (@headers)
{
  
  
  my $file = File::Spec->catfile($head_loc, $header);

   
  warn " Creating Config for: $file at \n";

   my $FH;
   open $FH, '<'.$file or warn "Cannot find $file please set \$ENV{SDL_GFX_LOC} to point to a different location  : $!";
   
   next if !$FH;

   grep { $_ =~ /^(\s+|)(\S+) (\S+) (\*|)(\S+)(\()/; print "$5 \n" if $5 } <$FH>;

   close $FH

}




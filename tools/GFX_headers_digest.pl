use strict;
use warnings;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;


my @headers = qw/ SDL_gfxPrimitives.h SDL_rotozoom.h SDL_framerate.h SDL_imageFilter.h SDL_gfxBlitFunc.h /;



foreach my $header (@headers)
{
  
  
  my $file = '/usr/include/SDL/'.$header;
print " ################## $file ####################\n";
 # my $c = C::Scan->new('filename' => $file);
  
  # my $fdec = $c->get('fdecls');
   
   open my $FH, '<'.$file or die $!;
   
   grep { $_ =~ /^(\s+|)(\S+) (\S+) (\*|)(\S+)(\()/; print "$5 \n" if $5 } <$FH>;

}




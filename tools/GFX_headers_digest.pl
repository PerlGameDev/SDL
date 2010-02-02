use strict;
use warnings;
use Data::Dumper;
use C::Scan;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;


my @headers = qw/ SDL_gfxPrimitives.h SDL_rotozoom.h SDL_framerate.h SDL_imageFilter.h SDL_gfxBlitFunc.h /;



foreach my $header (@headers)
{
  
  
  my $file = '/usr/include/SDL/'.$header;
print " ################## $file ####################\n";
  my $c = C::Scan->new('filename' => $file);
  
   my $fdec = $c->get('fdecls');
   
   grep { my @line = split ' ', $_ ; print STDERR $line[2]."\n" if $line[2] !~ /__/; } @{$fdec};

}




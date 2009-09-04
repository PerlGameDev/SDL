use ExtUtils::MakeMaker;
$Verbose = 1;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'SDL::Rect',
    'VERSION_FROM' => 'Rect.pm', # finds $VERSION
    'LIBS'	=> scalar `sdl-config --libs`,   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> scalar `sdl-config --cflags`,     # e.g., '-I/usr/include/other' 
    'XSPROTOARG'	=> '-noprototypes',
    'TYPEMAPS'	=> ['perlobject.map' ],
);

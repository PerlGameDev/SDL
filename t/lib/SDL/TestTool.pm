package SDL::TestTool;
use strict;
use warnings;
use IO::CaptureOutput qw(capture);
use SDL;

my %inits =
(
	0x00000001 => 'SDL_INIT_TIMER',
	0x00000010 => 'SDL_INIT_AUDIO',
	0x00000020 => 'SDL_INIT_VIDEO',
	0x00000100 => 'SDL_INIT_CDROM',
	0x00000200 => 'SDL_INIT_JOYSTICK',
	0x00100000 => 'SDL_INIT_NOPARACHUTE',
	0x01000000 => 'SDL_INIT_EVENTTHREAD',
	0x0000FFFF => 'SDL_INIT_EVERYTHING',

);

sub init {
    my ($self, $init) = @_;
    my $stdout = '';
    my $stderr = '';

    if( $init == SDL_INIT_VIDEO)
    {
	    if( $^O !~ /win/i && !$ENV{DISPLAY} )
	    {
		    warn '$DISPLAY is not set! Cannot Init Video';
		    return ;
	    }
    }

    capture { SDL::init($init) } \$stdout, \$stderr;
    if ( $stderr ne '' )
    {
	    warn 'Init '.$inits{$init}.' failed with SDL error: '. SDL::get_error()."\nand stderr $stderr\n";
    }
    
    return !($stderr ne '');
}


1;

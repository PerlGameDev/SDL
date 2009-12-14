package SDL::TestTool;
use strict;
use warnings;
use IO::CaptureOutput qw(capture);
use SDL;
use SDL::AudioSpec;
use SDL::Audio;
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

    if( !$ENV{SDL_BSD_TEST} and $^O =~ /bsd|solaris/i) 
    {
	    warn "SDL Perl is experimental in BSD environments. \n Turn on SDL_BSD_TEST to test your system.";
	    return ;
    }

    if( $init == SDL_INIT_TIMER and !$ENV{SDL_BSD_TEST} and $^O =~ /bsd|solaris/i )
    {
	    warn ' Timer is REALLY experimental with BSD environments';
	    return ;
    } 

    if( $init == SDL_INIT_VIDEO)
    {
	    if( $^O !~ /win/i && !$ENV{DISPLAY} )
	    {
		    warn '$DISPLAY is not set! Cannot Init Video';
		    return ;
	    }
    }

    if( $init == SDL_INIT_AUDIO)
    {
	 if (test_audio_open() != 0) 
	 {
		 warn "Couldn't use a valid audio device";
		 return ;
	 }
	SDL::quit();
    }

    capture { SDL::init($init) } \$stdout, \$stderr;
    if ( $stderr ne '' )
    {
	    warn 'Init '.$inits{$init}.' failed with SDL error: '. SDL::get_error()."\nand stderr $stderr\n";
    }
    
    return !($stderr ne '');
}

sub test_audio_open
{
my $desired = SDL::AudioSpec->new;
$desired->freq(44100);
$desired->format(SDL::Constants::AUDIO_S16);
$desired->channels(2);
$desired->samples(4096);


my $obtained = SDL::AudioSpec->new;
return  SDL::Audio::open( $desired, $obtained );


}
1;

package SDL::TestTool;
use strict;
use warnings;
use IO::CaptureOutput qw(capture);
use SDL;

sub init_audio {
    my $stdout = '';
    my $stderr = '';
    capture { SDL::init(SDL_INIT_AUDIO) } \$stdout, \$stderr;
    return ( $stderr ne '' );
}

1;

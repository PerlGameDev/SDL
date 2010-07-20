#!perl 
# basic testing of SDL::SMPEG

BEGIN {
    unshift @INC, 'blib/lib', 'blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('smpeg') ) {
    plan( tests => 2 );
}
else {
    plan( skip_all =>
          ( SDL::Config->has('smpeg') ? '' : ' smpeg support not compiled' ) );
}

use_ok('SDL::SMPEG');

can_ok(
    'SDL::SMPEG', qw/
      new
      error
      audio
      video
      volume
      display
      scale
      play
      pause
      stop
      rewind
      seek
      skip
      loop
      region
      frame
      info
      status
      /
);

sleep(2);

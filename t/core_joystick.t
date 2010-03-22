#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use SDL::Joystick;
my @done = qw/num_joysticks/;
can_ok( "SDL::Joystick", @done);

is( SDL::Joystick::num_joysticks() >= 0, 1, "[num_joysticks] ran");

SKIP:
{
    SDL::init_sub_system(SDL_INIT_JOYSTICK);

    skip "Need a joystick for below tests", 1 unless (SDL::Joystick::num_joysticks() > 0 );
     
    my $joy = SDL::Joystick->new(0);
    pass"[new] can open joystick";

}

my @left = qw/
name  
opened  
index  
num_axes  
num_balls  
num_hats  
num_buttons  
update  
get_axis  
get_hat  
get_button  
get_ball  
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach(@left)
    
}
print "$why\n";

done_testing();
sleep(2);

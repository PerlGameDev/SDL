#!/usr/bin/perl 
#==========================================================================
#
#         FILE:  SDLx_Sound.pl
#
#        USAGE:  ./examples/SDLx_Sound.pl  
#                  
#
#  DESCRIPTION:  Sound tests
#                A SDLx::Sound can play, pause, resume and stop
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Ricardo Filipo (rf), ricardo.filipo@gmail.com
#      COMPANY:  Mito-Lógica design e soluções de comunicação ltda
#      VERSION:  1.0
#      CREATED:  16-08-2010 21:47:33
#     REVISION:  ---
#==========================================================================

use strict;
use warnings;

use lib 'lib';
use SDL;
use SDLx::Sound;
use SDLx::App;
use SDL::Event;
use SDL::Events; 

my $app = SDLx::App->new(
		height => 120,
		width  => 480,
		depth  => 16,
		title  => 'Sound example',
		);
my $snd = SDLx::Sound->new();

# load and play a sound
my $play = $snd->play('test/data/sample.wav');

# pause or resume on keydown 
$app->add_event_handler( sub{
		my $e = $_[0];
		if( $e->type == SDL_KEYDOWN )
		{ 
		print "Ai\n"; 
		if($play){
		$snd->pause;
		$play=0;
		}else{
		$snd->resume;
		$play=1;
		} 
		}    
		} );

$app->run();


#!/usr/bin/env perl
#
#
# testjoystick.pl
#
#	adapted from SDL-1.2.x/test/testjoystick.c

use strict;
#use warnings;

use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Event;


sub WatchJoystick($){
	(my $joystick) = @_;
	my $screenWidth = 640;
	my $screenHeight = 480;

	my $app = new SDL::App(-title => "Joystick Test",
			       -width => $screenWidth,
			       -height => $screenHeight,
			       -depth=> 16 );
	#Print information about the joystick we are watching
	my $name = SDL::JoystickName(SDL::JoystickIndex($joystick));
	print "Watching joystick ".SDL::JoystickIndex($joystick).
	      ": (".($name ? $name : "Unknown Joystick" ).")\n";
	print "Joystick has ".SDL::JoystickNumAxes($joystick)." axes, ".
	      SDL::JoystickNumHats($joystick)." hats, ".
	      SDL::JoystickNumBalls($joystick)." balls, and ".
	      SDL::JoystickNumButtons($joystick)." buttons\n";
	
	my $event = new SDL::Event;
	my $done = 0;	
	my $colorWhite = new SDL::Color(-r=>255, -g=>255, -b=>255);
	my $colorBlack = new SDL::Color();
	my @axisRect = ();
	my $numAxes=SDL::JoystickNumAxes($joystick);


	while(!$done)
	  {
		while($event->poll())
		  {
			if($event->type() eq SDL::JOYAXISMOTION())
			  {
				print "Joystick ".SDL::JoyAxisEventWhich($$event).
				  " axis ".SDL::JoyAxisEventAxis($$event).
					" value: ".SDL::JoyAxisEventValue($$event)."\n";
			  } 
			elsif($event->type() eq SDL::JOYHATMOTION())
			  {
				print "Joystick ".SDL::JoyHatEventWhich($$event).
				  " hat ".SDL::JoyHatEventHat($$event);
				if(SDL::JoyHatEventValue($$event) == SDL::HAT_CENTERED() )
				  {
					print " centered";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_UP() ) { 
					print " up";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_RIGHT() ) {
					print " right";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_DOWN() ) {
					print " down";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_LEFT()) {
					print " left";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_RIGHTUP() ) { 
					print " right & up";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_RIGHTDOWN() ) {
					print " right & down";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_LEFTDOWN() ) {
					print " left & down";
				  } elsif(SDL::JoyHatEventValue($$event) == SDL::HAT_LEFTUP()) {
					print " left & up";
				  }
				print "\n";
			  } elsif($event->type() eq SDL::JOYBALLMOTION()){
				print "Joystick ".SDL::JoyBallEventWhich($$event).
				  " ball ".SDL::JoyBallEventBall($$event).
				      " delta: (".SDL::JoyBallEventXrel($$event).
				      ",".SDL::JoyBallEventYrel($$event)."\n";
			} elsif($event->type() eq SDL::JOYBUTTONDOWN()){
				print "Joystick ".SDL::JoyButtonEventWhich($$event).
				      " button ".SDL::JoyButtonEventButton($$event)." down\n";
			} elsif($event->type() eq SDL::JOYBUTTONUP()){
				print "Joystick ".SDL::JoyButtonEventWhich($$event).
				      " button ".SDL::JoyButtonEventButton($$event)." up\n";
			} elsif($event->type() eq SDL_QUIT() or 
			        ($event->type() eq SDL_KEYDOWN() and 
				 $event->key_sym() == SDLK_ESCAPE)){
				$done = 1;
			}
			


			#Update visual joystick state
			for(my $i =0; $i < SDL::JoystickNumButtons($joystick); $i++)
			  {
				my $rect = new SDL::Rect( -width => 32,
										  -height => 32,
										  -x => $i*34,
										  -y => $screenHeight-34); 
				if(SDL::JoystickGetButton($joystick, $i) eq SDL::PRESSED())
				  {
					$app->fill($rect, $colorWhite); 
				  } else {
					$app->fill($rect, $colorBlack); 
				  }
				$app->update($rect);
			  }


			  for (my $i = 0; $i < $numAxes; $i+=1)
				{
				  #Remove previous axis box
				  if($axisRect[$i]){
					$app->fill($axisRect[$i], $colorBlack);
					$app->update($axisRect[$i]);
				  }
				  # Draw the axis
				  my $ox = SDL::JoystickGetAxis($joystick, $i);
				  my $x= abs ($ox/256);
				  if( $x < 0) {
					$x=0;
				  } elsif ( $x > ($screenWidth-16) ){
					$x = $screenWidth-16;
				  }


				  if ($ox < 0)
					{
					  $axisRect[$i] = new SDL::Rect( -width=> $x,
													 -height=> 32,
													 -x => ($screenWidth/2) - $x,
													 -y => $i*34
												   );
					}
				  else
					{
					  $axisRect[$i] = new SDL::Rect( -width=> $x,
													 -height=> 32,
													 -x => $screenWidth/2 ,
													 -y => $i*34
												   );
					}


				  $app->fill($axisRect[$i], $colorWhite);
				  $app->update($axisRect[$i]);
				}
		  }
	  }
  }
				
die "Could not initialize SDL: ", SDL::GetError()
	if( 0 > SDL::Init(SDL_INIT_JOYSTICK()));

printf "There are %d joysticks attched\n", SDL::NumJoysticks();
for(my $i = 0; $i < SDL::NumJoysticks(); $i++){
	my $name = SDL::JoystickName($i);
	print "Joystick ".$i.": ".($name ? $name : "Unknown Joystick")."\n"; 
}

if ( $ARGV[0] ne undef){
	my $joystick = SDL::JoystickOpen($ARGV[0]);
	if(!$joystick){
		print "Couldn't open joystick ".$ARGV[0].": ".SDL::GetError()."\n";
	} else {
		WatchJoystick($joystick);
		SDL::JoystickClose($joystick);
	}
	SDL::QuitSubSystem(SDL_INIT_JOYSTICK());
}


exit;

sub draw_axis_method_2()
{
}

__DATA__
sub draw_axis_method_1()
{
				for (my $i = 0; $i < ($numAxes/2); $i+=2)
				  {
					#Remove previous axis box
					if($axisRect[$i]){
					  $app->fill($axisRect[$i], $colorBlack);
					  $app->update($axisRect[$i]);
					}
					# Draw the X/Y axis
					my $x = SDL::JoystickGetAxis($joystick, $i)+32768;
					$x *= $screenWidth;
					$x /= 65535;
					if( $x < 0) {
					  $x=0;
					} elsif ( $x > ($screenWidth-16) ){
					  $x = $screenWidth-16;
					}
					my $y = SDL::JoystickGetAxis($joystick, $i+1)+32768;
					$y *= $screenHeight;
					$y /= 65535;
					if( $y < 0) {
					  $y=0;
					} elsif ( $y > ($screenHeight-16) ){
					  $y = $screenHeight-16; 
					}
					$axisRect[$i] = new SDL::Rect( -width=> 16,
												   -height=> 16,
												   -x => $x,
												   -y => $y);
					$app->fill($axisRect[$i], $colorWhite);
					$app->update($axisRect[$i]);
				  }
			  }

}

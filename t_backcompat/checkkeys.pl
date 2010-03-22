#!/usr/bin/env perl

use SDL;
use SDL::App;
use SDL::Event;

my %options;

die <<USAGE if ( in $ARGV[0], qw/ -? -h --help /);
usage: $0 [-hw] [-fullscreen] [-width 640] [-height 480] [-bpp 24]
USAGE

for ( 0 .. @ARGV-1 )
{
	$options{$ARGV[$_]} = $ARGV[$_ + 1] || 1;
}

$options{-flags} = SDL_SWSURFACE;
$options{-flags} |= SDL_HWPALETTE if ( $options{-hw} );
$options{-flags} |= SDL_FULLSCREEN if ( $options{-fullscreen} );

$options{-title} = $0;

$options{-width} ||= 640;
$options{-height} ||= 480;
$options{-depth} ||= $options{-bpp} || 24;

my $app = new SDL::App %options;

# SDL::EventState(SDL_KEYUP,SDL_DISABLE);

sub print_modifiers 
{
	$mod = SDL::GetModState();

	print " modifiers:", 
		($mod & KMOD_LSHIFT) ? " LSHIFT" : "",
		($mod & KMOD_RSHIFT) ? " RSHIFT" : "",
		($mod & KMOD_LCTRL) ? " LCTRL" : "",
		($mod & KMOD_RCTRL) ? " RCTRL" : "",
		($mod & KMOD_LALT) ? " LALT" : "",
		($mod & KMOD_RALT) ? " RALT" : "",
		($mod & KMOD_LMETA) ? " LMETA" : "",
		($mod & KMOD_RMETA) ? " RMETA" : "",
		($mod & KMOD_CAPS) ? " CAPS" : "",
		($mod & KMOD_NUM) ? " NUM" : "",
		($mod & KMOD_MODE) ? " MODE" : "",
		"\n" ;
}

sub print_key
{
	my ($e) = @_;

 	print "pressed " if (SDL::KeyEventState($e) == SDL_PRESSED);
	print "released " if ( SDL::KeyEventState($e) == SDL_RELEASED);

	my $sym = SDL::KeyEventSym($e);

	if ($sym) {
		print SDL::GetKeyName($sym);
	} else {
		printf "Unknown Key (scancode = %d) ", SDL::KeyEventScanCode($e);
	}

}

my $event = new SDL::Event;

my $done = 0;

$process_keys = sub {
		print_key($_[0]);
		print_modifiers();	
	};

my %events = (
	SDL_KEYUP() =>  $process_keys,
	SDL_KEYDOWN() =>  $process_keys,
	SDL_QUIT() => sub { $done = 1; },
);

while (!$done && $event->wait())
{
	if ( $events{$event->type()}) {
		&{$events{$event->type()}}($$event);
	}
};


use strict;
use warnings;
use Test::Most 'bail';
use File::Spec 'catfile';

BEGIN {
	my @modules = qw /
		SDL
		SDL::Video
		SDL::Color
		SDL::Surface
		SDL::Config
		SDL::Overlay
		SDL::Rect
		SDL::Time
		SDL::Events
		SDL::Event
		SDL::Mouse
		SDL::Joystick
		SDL::Cursor
		SDL::Audio
		SDL::AudioCVT
		SDL::AudioSpec
		SDL::CDROM
		SDL::CDTrack
		SDL::CD
		SDL::MultiThread
		SDL::PixelFormat
		SDL::VideoInfo

		SDL::GFX::BlitFunc
		SDL::GFX::Framerate
		SDL::GFX::FPSManager
		SDL::GFX::ImageFilter
		SDL::GFX::Primitives
		SDL::GFX::Rotozoom

		SDL::Image

		SDL::Mixer
		SDL::Mixer::Samples
		SDL::Mixer::Channels
		SDL::Mixer::Groups
		SDL::Mixer::Music
		SDL::Mixer::Effects
		SDL::Mixer::MixChunk
		SDL::Mixer::MixMusic

		SDL::Pango
		SDL::Pango::Context

		SDL::TTF
		SDL::TTF::Font

		SDL::Version

		SDLx::App
		SDLx::Sprite
		SDLx::Sprite::Animated
		SDLx::FPS
		SDLx::SFont
		SDLx::Validate
		SDLx::Surface
		SDLx::Surface::TiedMatrix
		SDLx::Surface::TiedMatrixRow

		SDLx::Controller
		SDLx::Controller::Interface
		SDLx::Controller::State
		SDLx::Controller::Timer

		SDLx::Sound

		/;

	my $tests = scalar @modules;

	my $load_test_strict = 0;

	if( $ENV{RELEASE_TESTING})
	{

		eval 'require Test::Strict';
		$load_test_strict = 1 unless $@;
	}
	foreach( @modules )
	{
		use_ok $_ ;
		if( $load_test_strict )
		{


			my $file = $_;

			my @files = split /::/, $file;

			$file = File::Spec->catfile( 'lib', @files );

			$file = $file.'.pm';

			eval 'Test::Strict::syntax_ok $file';
			pass unless $@;	
			eval 'Test::Stict::strict_ok $file';
			pass unless $@;
			eval 'Test::Strict::warnings_ok $file';
			pass unless $@;

		}
	}


}

done_testing();

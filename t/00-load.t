use strict;
use warnings;
use Test::Most 'bail';

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
		SDLx::Surface
		SDLx::Surface::TiedMatrix
		SDLx::Surface::TiedMatrixRow
		
	/;
	plan tests => scalar @modules;

	use_ok $_ foreach @modules;
}

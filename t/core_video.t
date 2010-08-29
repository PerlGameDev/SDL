#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Color;
use SDL::Surface;
use SDL::Config;
use SDL::Overlay;
use Test::More;
use SDL::Rect;
use SDL::Video;
use SDL::VideoInfo;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my @done = qw/
	get_video_surface
	get_video_info
	video_driver_name
	list_modes
	set_video_mode
	video_mode_ok
	update_rect
	update_rects
	flip
	set_colors
	set_palette
	set_gamma
	set_gamma_ramp
	map_RGB
	map_RGBA
	unlock_surface
	lock_surface
	convert_surface
	display_format
	display_format_alpha
	set_color_key
	set_alpha
	get_RGB
	get_RGBA
	load_BMP
	save_BMP
	fill_rect
	blit_surface
	set_clip_rect
	get_clip_rect
	lock_YUV_overlay
	unlock_YUV_overlay
	display_YUV_overlay
	GL_load_library
	GL_get_proc_address
	GL_get_attribute
	GL_set_attribute
	GL_swap_buffers
	get_gamma_ramp
	wm_set_caption
	wm_get_caption
	wm_set_icon
	wm_toggle_fullscreen
	wm_iconify_window
	wm_grab_input
	/;

can_ok( 'SDL::Video', @done );

is( SDL_SWSURFACE,     0,          'SDL_SWSURFACE should be imported' );
is( SDL_SWSURFACE(),   0,          'SDL_SWSURFACE() should also be available' );
is( SDL_HWSURFACE,     1,          'SDL_HWSURFACE should be imported' );
is( SDL_HWSURFACE(),   1,          'SDL_HWSURFACE() should also be available' );
is( SDL_ASYNCBLIT,     4,          'SDL_ASYNCBLIT should be imported' );
is( SDL_ASYNCBLIT(),   4,          'SDL_ASYNCBLIT() should also be available' );
is( SDL_OPENGL,        2,          'SDL_OPENGL should be imported' );
is( SDL_OPENGL(),      2,          'SDL_OPENGL() should also be available' );
is( SDL_OPENGLBLIT,    10,         'SDL_OPENGLBLIT should be imported' );
is( SDL_OPENGLBLIT(),  10,         'SDL_OPENGLBLIT() should also be available' );
is( SDL_RESIZABLE,     16,         'SDL_RESIZABLE should be imported' );
is( SDL_RESIZABLE(),   16,         'SDL_RESIZABLE() should also be available' );
is( SDL_HWACCEL,       256,        'SDL_HWACCEL should be imported' );
is( SDL_HWACCEL(),     256,        'SDL_HWACCEL() should also be available' );
is( SDL_SRCCOLORKEY,   4096,       'SDL_SRCCOLORKEY should be imported' );
is( SDL_SRCCOLORKEY(), 4096,       'SDL_SRCCOLORKEY() should also be available' );
is( SDL_RLEACCELOK,    8192,       'SDL_RLEACCELOK should be imported' );
is( SDL_RLEACCELOK(),  8192,       'SDL_RLEACCELOK() should also be available' );
is( SDL_RLEACCEL,      16384,      'SDL_RLEACCEL should be imported' );
is( SDL_RLEACCEL(),    16384,      'SDL_RLEACCEL() should also be available' );
is( SDL_SRCALPHA,      65536,      'SDL_SRCALPHA should be imported' );
is( SDL_SRCALPHA(),    65536,      'SDL_SRCALPHA() should also be available' );
is( SDL_ANYFORMAT,     268435456,  'SDL_ANYFORMAT should be imported' );
is( SDL_ANYFORMAT(),   268435456,  'SDL_ANYFORMAT() should also be available' );
is( SDL_DOUBLEBUF,     1073741824, 'SDL_DOUBLEBUF should be imported' );
is( SDL_DOUBLEBUF(),   1073741824, 'SDL_DOUBLEBUF() should also be available' );
is( SDL_FULLSCREEN,    0x80000000, 'SDL_FULLSCREEN should be imported' );
is( SDL_FULLSCREEN(),  0x80000000, 'SDL_FULLSCREEN() should also be available' );
is( SDL_HWPALETTE,     536870912,  'SDL_HWPALETTE should be imported' );
is( SDL_HWPALETTE(),   536870912,  'SDL_HWPALETTE() should also be available' );
is( SDL_PREALLOC,      16777216,   'SDL_PREALLOC should be imported' );
is( SDL_PREALLOC(),    16777216,   'SDL_PREALLOC() should also be available' );

is( SDL_IYUV_OVERLAY, 1448433993, 'SDL_IYUV_OVERLAY should be imported' );
is( SDL_IYUV_OVERLAY(), 1448433993,
	'SDL_IYUV_OVERLAY() should also be available'
);
is( SDL_UYVY_OVERLAY, 1498831189, 'SDL_UYVY_OVERLAY should be imported' );
is( SDL_UYVY_OVERLAY(), 1498831189,
	'SDL_UYVY_OVERLAY() should also be available'
);
is( SDL_YUY2_OVERLAY, 844715353, 'SDL_YUY2_OVERLAY should be imported' );
is( SDL_YUY2_OVERLAY(), 844715353,
	'SDL_YUY2_OVERLAY() should also be available'
);
is( SDL_YV12_OVERLAY, 842094169, 'SDL_YV12_OVERLAY should be imported' );
is( SDL_YV12_OVERLAY(), 842094169,
	'SDL_YV12_OVERLAY() should also be available'
);
is( SDL_YVYU_OVERLAY, 1431918169, 'SDL_YVYU_OVERLAY should be imported' );
is( SDL_YVYU_OVERLAY(), 1431918169,
	'SDL_YVYU_OVERLAY() should also be available'
);

is( SDL_LOGPAL,    0x01, 'SDL_LOGPAL should be imported' );
is( SDL_LOGPAL(),  0x01, 'SDL_LOGPAL() should also be available' );
is( SDL_PHYSPAL,   0x02, 'SDL_PHYSPAL should be imported' );
is( SDL_PHYSPAL(), 0x02, 'SDL_PHYSPAL() should also be available' );

is( SDL_GRAB_OFF,     0,  'SDL_GRAB_OFF should be imported' );
is( SDL_GRAB_OFF(),   0,  'SDL_GRAB_OFF() should also be available' );
is( SDL_GRAB_ON,      1,  'SDL_GRAB_ON should be imported' );
is( SDL_GRAB_ON(),    1,  'SDL_GRAB_ON() should also be available' );
is( SDL_GRAB_QUERY,   -1, 'SDL_GRAB_QUERY should be imported' );
is( SDL_GRAB_QUERY(), -1, 'SDL_GRAB_QUERY() should also be available' );

#needs to be done before set_video_mode
my $glVal = SDL::Video::GL_load_library('this/should/fail');

is( $glVal, -1, '[GL_load_library] Failed appropriately' );

TODO: {
	local $TODO = 'These should be tested with OS specific DLL or SO';
	is( SDL::Video::GL_load_library('t/realGL.so'),
		0, '[GL_load_libary] returns 0 on success'
	);

	# this gets set by GL_load_library => SDL_GL_LOADLIBARY. How do we get this from XS though?
	# below t/realGL.so needs to use SDL_GL_LOADLIBRARY
	isnt(
		SDL::Video::GL_get_proc_address('t/realGL.so'),
		0, '[GL_get_proc_address] returns not null on success'
	);
	is( SDL::Video::GL_set_attribute( SDL_GL_DOUBLEBUFFER, 1 ),
		0, '[GL_set_attribute] returns 0 on success'
	);
	my $tdisplay = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );
	my $value = -3;
	SDL::Video::GL_set_attribute( SDL_GL_DOUBLEBUFFER, $value );
	is( $value, 1, '[GL_get_attribute] returns 1 on success as set above' );

	SDL::Video::GL_swap_buffers();
	pass('[GL_swap_buffers] should work because Double Buffering is turned on');

}

my $video_info = SDL::Video::get_video_info();
isa_ok(
	$video_info, 'SDL::VideoInfo',
	'[get_video_info] Checking if we get videoinfo ref back'
);

my $list_modes = SDL::Video::list_modes(
	$video_info->vfmt,
	SDL_NOFRAME | SDL_HWSURFACE | SDL_FULLSCREEN
);
is( ref($list_modes), 'ARRAY', '[list_modes] Returned an ARRAY! ' );

my @modes = @{$list_modes};

if ( $#modes > 0 ) {
	foreach my $mode (@modes) {
		ok( $mode->w > 0 && $mode->h > 0,
			'[list_modes] available mode: ' . $mode->w . ' x ' . $mode->h
		);
	}
} elsif ( $#modes == 0 ) {
	is( $modes[0], 'all', '[list_modes] available mode: all' );
}

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );

if ( !$display ) {
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

#diag('Testing SDL::Video');

isa_ok(
	SDL::Video::get_video_surface(),
	'SDL::Surface',
	'[get_video_surface] Checking if we get a surface ref back'
);

my $driver_name = SDL::Video::video_driver_name();
pass '[video_driver_name] This is your driver name: ' . $driver_name;

cmp_ok(
	SDL::Video::video_mode_ok( 100, 100, 16, SDL_SWSURFACE ),
	'>=', 0, "[video_mode_ok] Checking if an integer was return"
);

$display = SDL::Video::set_video_mode( 100, 100, 16, SDL_SWSURFACE );

isa_ok(
	$display, 'SDL::Surface',
	'[set_video_more] Checking if we get a surface ref back'
);

#TODO: Write to surface and check inf pixel in that area got updated.

SDL::Video::update_rect( $display, 0, 0, 0, 0 );

#TODO: Write to surface and check inf pixel in that area got updated.
SDL::Video::update_rects( $display, SDL::Rect->new( 0, 10, 20, 20 ) );

my $value = SDL::Video::flip($display);
is( ( $value == 0 ) || ( $value == -1 ), 1, '[flip] returns 0 or -1' );

SKIP:
{
	skip( "These negative test may cause older versions of SDL to crash", 2 )
		unless $ENV{NEW_SDL};
	$value = SDL::Video::set_colors( $display, 0, SDL::Color->new( 0, 0, 0 ) );
	is( $value, 0, '[set_colors] returns 0 trying to write to 32 bit display' );

	$value = SDL::Video::set_palette( $display, SDL_LOGPAL | SDL_PHYSPAL, 0 );

	is( $value, 0,
		'[set_palette] returns 0 trying to write to 32 bit surface'
	);
}
SDL::delay(100);

my @b_w_colors;

for ( my $i = 0; $i < 256; $i++ ) {
	$b_w_colors[$i] = SDL::Color->new( $i, $i, $i );
}
my $overlay = SDL::Overlay->new( 200, 220, SDL_IYUV_OVERLAY, $display );

is( SDL::Video::lock_YUV_overlay($overlay),
	0, '[lock_YUV_overlay] returns a 0 on success'
);
SDL::Video::unlock_YUV_overlay($overlay);
pass '[unlock_YUV_overlay] ran';
my $display_at_rect = SDL::Rect->new( 0, 0, 100, 100 );
is( SDL::Video::display_YUV_overlay( $overlay, $display_at_rect ),
	0, '[display_YUV_overlay] returns 0 on success'
);

my $bmp_surface;
my $hwdisplay;

SKIP:
{
	skip( "No hardware surface available", 26 )
		unless $video_info->hw_available();

	$hwdisplay = SDL::Video::set_video_mode( 640, 480, 8, SDL_HWSURFACE );

	if ( !$hwdisplay ) {
		plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
	}

	$value = SDL::Video::set_colors( $hwdisplay, 0 );
	is( $value, 0,
		'[set_colors] returns 0 trying to send empty colors to 8 bit surface'
	);

	$value = SDL::Video::set_palette( $hwdisplay, SDL_LOGPAL | SDL_PHYSPAL, 0 );

	is( $value, 0,
		'[set_palette] returns 0 trying to send empty colors to 8 bit surface'
	);

	$value = SDL::Video::set_colors( $hwdisplay, 0, @b_w_colors );
	is( $value, 1, '[set_colors] returns ' . $value );

	$value = SDL::Video::set_palette(
		$hwdisplay, SDL_LOGPAL | SDL_PHYSPAL,
		0,          @b_w_colors
	);

	is( $value, 1, '[set_palette] returns 1' );

	$value = SDL::Video::lock_surface($hwdisplay);
	pass '[lock_surface] ran returned: ' . $value;

	SDL::Video::unlock_surface($hwdisplay);
	pass '[unlock_surface] ran';

	is( SDL::Video::map_RGB( $hwdisplay->format, 10, 10, 10 ) >= 0,
		1, '[map_RGB] maps correctly to 8-bit surface'
	);
	is( SDL::Video::map_RGBA( $hwdisplay->format, 10, 10, 10, 10 ) >= 0,
		1, '[map_RGBA] maps correctly to 8-bit surface'
	);

	TODO:
	{
		local $TODO = "These test case test a very specific test scenario which might need to be re tought out ...";

		isa_ok(
			SDL::Video::convert_surface( $hwdisplay, $hwdisplay->format, SDL_SRCALPHA ),
			'SDL::Surface',
			'[convert_surface] Checking if we get a surface ref back'
		);
		isa_ok(
			SDL::Video::display_format($hwdisplay),
			'SDL::Surface', '[display_format] Returns a SDL::Surface'
		);
		isa_ok(
			SDL::Video::display_format_alpha($hwdisplay),
			'SDL::Surface', '[display_format_alpha] Returns a SDL::Surface'
		);
	}

	is( SDL::Video::set_color_key( $hwdisplay, SDL_SRCCOLORKEY, SDL::Color->new( 0, 10, 0 ) ),
		0,
		'[set_color_key] Returns 0 on success'
	);

	is( SDL::Video::set_alpha( $hwdisplay, SDL_SRCALPHA, 100 ),
		0, '[set_alpha] Returns 0 on success'
	);

	is_deeply(
		SDL::Video::get_RGB( $hwdisplay->format, 0 ),
		[ 0, 0, 0 ],
		'[get_RGB] returns r,g,b'
	);

	is_deeply(
		SDL::Video::get_RGBA( $hwdisplay->format, 0 ),
		[ 0, 0, 0, 255 ],
		'[get_RGBA] returns r,g,b,a'
	);

	my $bmp = 't/core_video.bmp';
	unlink($bmp) if -f $bmp;
	SDL::Video::save_BMP( $hwdisplay, $bmp );
	ok( -f $bmp, '[save_BMP] creates a file' );
	$bmp_surface = SDL::Video::load_BMP($bmp);
	isa_ok(
		$bmp_surface, 'SDL::Surface',
		'[load_BMP] returns an SDL::Surface'
	);
	unlink($bmp) if -f $bmp;

	my $pixel = SDL::Video::map_RGB( $hwdisplay->format, 255, 127, 0 );
	SDL::Video::fill_rect( $hwdisplay, SDL::Rect->new( 0, 0, 32, 32 ), $pixel );
	ok( 1, '[fill_rect] filled rect' );

	my $clip_rect = SDL::Rect->new( 0, 0, 10, 20 );
	SDL::Video::get_clip_rect( $hwdisplay, $clip_rect );
	is( $clip_rect->x, 0,   '[get_clip_rect] returns a rect with x 0' );
	is( $clip_rect->y, 0,   '[get_clip_rect] returns a rect with y 0' );
	is( $clip_rect->w, 640, '[get_clip_rect] returns a rect with w 640' );
	is( $clip_rect->h, 480, '[get_clip_rect] returns a rect with h 480' );
	SDL::Video::set_clip_rect( $hwdisplay, SDL::Rect->new( 10, 20, 100, 200 ) );
	SDL::Video::get_clip_rect( $hwdisplay, $clip_rect );
	is( $clip_rect->x, 10,  '[get_clip_rect] returns a rect with x 10' );
	is( $clip_rect->y, 20,  '[get_clip_rect] returns a rect with y 20' );
	is( $clip_rect->w, 100, '[get_clip_rect] returns a rect with w 100' );
	is( $clip_rect->h, 200, '[get_clip_rect] returns a rect with h 200' );
}

SKIP:
{
	skip( "No window manager available", 11 )
		unless $video_info->wm_available();

	my ( $title, $icon ) = @{ SDL::Video::wm_get_caption() };
	is( $title, undef, '[wm_get_caption] title is undef' );
	is( $icon,  undef, '[wm_get_caption] icon is undef' );
	SDL::Video::wm_set_caption( 'Title text', 'Icon text' );
	( $title, $icon ) = @{ SDL::Video::wm_get_caption() };
	is( $title, 'Title text', '[wm_set_caption set title]' );
	is( $icon,  'Icon text',  '[wm_set_caption set icon]' );

	SKIP:
	{
		skip( "No hardware surface available", 1 )
			unless $video_info->hw_available();
		SDL::Video::wm_set_icon($bmp_surface);
		pass '[wm_set_icon] ran';
	}

	SKIP:
	{
		skip 'Turn on SDL_GUI_TEST', 6 unless $ENV{SDL_GUI_TEST};
		SDL::Video::wm_grab_input(SDL_GRAB_ON);
		pass '[wm_grab_input] ran with SDL_GRAB_ON';

		is( SDL::Video::wm_grab_input(SDL_GRAB_QUERY),
			SDL_GRAB_ON, '[wm_grab_input] Got Correct grab mode back'
		);

		SDL::Video::wm_grab_input(SDL_GRAB_OFF);
		pass '[wm_grab_input] ran with SDL_GRAB_OFF';

		is( SDL::Video::wm_grab_input(SDL_GRAB_QUERY),
			SDL_GRAB_OFF, '[wm_grab_input] Got Correct grab mode back'
		);

		my $ic = SDL::Video::wm_iconify_window();
		is( $ic, 1, '[wm_iconify_window] ran' );

		SKIP:
		{
			skip( "No hardware surface available", 1 )
				unless $video_info->hw_available();
			SDL::Video::wm_toggle_fullscreen($hwdisplay);
			pass '[wm_toggle_fullscreen] ran';
		}
	}
}

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Are we still alive? Checking for segfaults';

sleep(1);

done_testing();

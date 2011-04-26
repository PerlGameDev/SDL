# tests for SDLx::Music
# we're assuming all SDLx::Music::Data stuff works because that's a separate test

use Test::More;
use lib 't/lib';
use SDL;
use SDL::TestTool;
use SDL::Config;
use SDLx::Music;
use SDLx::Music::Data;
use SDL::Music;
use Scalar::Util 'weaken';

my $audiodriver = $ENV{SDL_AUDIODRIVER};
$ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
	plan( skip_all => 'Failed to init sound' );
} elsif ( !SDL::Config->has('SDL_mixer') ) {
	plan( skip_all => 'SDL_mixer support not compiled' );
}

can_ok(
	'SDLx::Music',
	qw/
		new
		data
		data_for
		has_data
		default
		load
		unload
		clear
		play
		pause
		stop
		last_played
		playing
		paused
		vol
		fade_out
		fading
		rewind
		pos
	/,
);

ok(my $music      = SDLx::Music->new, 'music - Empty constructor');
ok(my $music_name = SDLx::Music->new('foo'), 'music_name - Single-element constructor');
ok(my $music_hash = SDLx::Music->new(
	sample  => {},
	silence => undef,
	tribe_i => undef,
), 'music_hash - Hash constructor');
ok(my $music_hash2 = SDLx::Music->new(
	sample  => 'test/data/sample.wav',
	silence => {file => 'test/data/silence.wav'},
	tribe_i => $music_hash->data('tribe_i')->dir('test/data/')->ext('.wav'),
), 'music_hash2 - Hash constructor with file params');

isa_ok($music,       'SDLx::Sound', 'music');
isa_ok($music_name,  'SDLx::Sound', 'music_name');
isa_ok($music_hash,  'SDLx::Sound', 'music_hash');
isa_ok($music_hash2, 'SDLx::Sound', 'music_hash2');

isa_ok($music      ->default, 'SDLx::Music::DefaultData', 'music->default');
isa_ok($music_name ->default, 'SDLx::Music::DefaultData', 'music_name->default');
isa_ok($music_hash ->default, 'SDLx::Music::DefaultData', 'music_hash->defalt');
isa_ok($music_hash2->default, 'SDLx::Music::DefaultData', 'music_hash2->default');
isa_ok(SDLx::Music ->default, 'SDLx::Music::DefaultData', 'SDLx::Music->default');

$music->default      ->fade_out(1);
$music_name->default ->fade_out(2);
$music_hash->default ->fade_out(3);
$music_hash2->default->fade_out(4);
SDLx::Music->default ->fade_out(5);
is($music->default      ->fade_out, 1, 'default 1 is unique');
is($music_name->default ->fade_out, 2, 'default 2 is unique');
is($music_hash->default ->fade_out, 3, 'default 3 is unique');
is($music_hash2->default->fade_out, 4, 'default 4 is unique');
is(SDLx::Music->default ->fade_out, 5, 'default 5 is unique');

is_deeply($music->data,       {}, 'music->data correct');
is_deeply($music_name->data,  { foo => SDLx::Music::Data->new('foo') }, 'music_name->data correct');
is_deeply($music_hash->data,  {
	sample  => SDLx::Music::Data->new('sample'),
	silence => SDLx::Music::Data->new('silence'),
	tribe_i => SDLx::Music::Data->new('tribe_i'),
}, 'music_hash->data correct');
is_deeply($music_hash2->data, {
	sample  => SDLx::Music::Data->new('sample', $music_hash->data('sample')->file('test/data/sample.wav')),
	silence => SDLx::Music::Data->new('silence', 'test/data/silence.wav'),
	tribe_i => SDLx::Music::Data->new('tribe_i', {dir => 'test/data/', ext => '.wav'}),
}, 'music_hash2->data correct');

is($music      ->has_data, 0, 'music has no data');
is($music_name ->has_data, 1, 'music_name has 1 data');
is($music_hash ->has_data, 3, 'music_hash has 3 datas');
is($music_hash2->has_data, 3, 'music_name has 3 datas');

is($music->has_data, 'foo', undef, 'music has no foo');
is($music->has_data, 'foo', undef, 'music still has no foo');
my $foo = $music->data('foo');
isa_ok($foo, 'SDLx::Music::Data', 'the data');
is($music->data('foo'), $foo, 'data gives us back the same data');
is($music->has_data('foo'), $foo, 'now we have the data');
is($music->has_data, 1, 'and now we have 1 data');

$music_name->data($foo);
is($music_name->data('foo'), $foo, 'the data was put into another music');

$foo->file('yes');
my $bar = $music_name->data('bar');
$music_name->data(bar => $foo);
isnt($music_name->data('bar'), $bar, 'the old bar is different to the new bar');
my $bar = $music_name->data('bar');
isnt($music_name->data('bar'), $foo, 'the cloned bar is different to what it was cloned from');
is($music_name->data('bar')->file, 'yes', 'bar was cloned with foo\'s param');

$music_name->data_for(
	'foo',
	'bar',
	'baz',
	0,
);
is($music_name->data('foo'), $foo, 'foo didn\'t get changed by data_for');
is($music_name->data('bar'), $bar, 'bar didn\'t get changed by data_for');
ok($music_name->has_data('baz'), 'baz was created by data_for');
ok($music_name->has_data(0), '0 was created by data_for');
is($music_name->has_data, 4, 'music_name now has 4 datas');

$music->clear;
is($music->has_data, 0, 'music was cleared and now has no data');

$music_name->clear('foo', 0);
is($music_name->has_data, 2, 'cleared 2 of music_name\'s datas, now it has 2');
is($music->has_data('foo'), undef, 'music_name now has no foo');
is($music->has_data(0),     undef, 'music_name now has no 0');
is($music->has_data($foo),  undef, 'music_name has no foo object');
is($music->has_data($bar),  $bar,  'music_name has a bar object');

$music->data_for('foo', $bar);
is($music->has_data, 2, 'music has 2 datas again after data_for');
isnt($music->has_data('foo'), $foo, 'foo isn\'t the object foo');
is($music->has_data('bar'), $bar, 'bar is the object bar');
$music->data($foo);
isnt($music->has_data('foo'), $foo, 'foo still isn\'t foo after data');
$music->data_for($foo);
isnt($music->has_data('foo'), $foo, 'foo still isn\'t foo after data_for');
$music->data_for('bar');
is($music->has_data('bar'), $bar, 'bar is still bar after data_for');

$music_hash->default->dir('test/data/');
SDLx::Music->default->ext('.wav');
is($music_hash ->data('sample ')->path, 'test/data/sample.wav',  'music_hash sample path correct');
is($music_hash2->data('sample ')->path, 'test/data/sample.wav',  'music_hash2 sample path correct');
is($music_hash ->data('silence')->path, 'test/data/silence.wav', 'music_hash silence path correct');
is($music_hash2->data('silence')->path, 'test/data/silence.wav', 'music_hash2 silence path correct');
is($music_hash ->data('tribe_i')->path, 'test/data/tribe_i.wav', 'music_hash tribe_i path correct');
is($music_hash2->data('tribe_i')->path, 'test/data/tribe_i.wav', 'music_hash2 tribe_i path correct');

isnt($music_hash->data('sample'),  $music_hash2->data('sample'),  'sample is different in both musics');
isnt($music_hash->data('silence'), $music_hash2->data('silence'), 'silence is different in both musics');
isnt($music_hash->data('tribe_i'), $music_hash2->data('tribe_i'), 'tribe_i is different in both musics');

is($music_hash->data('sample') ->loaded, undef, 'no loaded music_hash sample');
is($music_hash->data('silence')->loaded, undef, 'no loaded music_hash silence');
is($music_hash->data('tribe_i')->loaded, undef, 'no loaded music_hash tribe_i');
$music_hash->load;
isa_ok(weaken(my $mix_sample  = $music_hash->data('sample') ->loaded), 'SDL::Mixer::MixMusic', 'loaded music_hash sample');
isa_ok(weaken(my $mix_silence = $music_hash->data('silence')->loaded), 'SDL::Mixer::MixMusic', 'loaded music_hash silence');
isa_ok(weaken(my $mix_tribe_i = $music_hash->data('tribe_i')->loaded), 'SDL::Mixer::MixMusic', 'loaded music_hash tribe_i');

$music_hash2->load('sample', $music_hash2->data('silence'));
isa_ok($music_hash2->data('sample') ->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 sample with name');
isa_ok($music_hash2->data('silence')->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 silence with data');
is($music_hash2->data('tribe_i')->loaded, undef, 'didn\'t load music_hash2 tribe_i');

$music_hash2->unload;
is($music_hash2->data('sample') ->loaded, undef, 'no loaded music_hash2 sample after unload');
is($music_hash2->data('silence')->loaded, undef, 'no loaded music_hash2 silence after unload');

$music_hash2->load('silence', $music_hash2->data('tribe_i'));
isa_ok($music_hash2->data('silence')->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 silence with name');
isa_ok($music_hash2->data('tribe_i')->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 tribe_i with data');
is($music_hash2->data('sample')->loaded, undef, 'didn\'t load music_hash2 sample');
$music_hash2->unload;

SDLx::Music->load($music_hash2->data('tribe_i'), $music_hash2->data('sample'));
isa_ok($music_hash2->data('sample') ->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 sample with class');
isa_ok($music_hash2->data('tribe_i')->loaded, 'SDL::Mixer::MixMusic', 'loaded music_hash2 tribe_i with class');
is($music_hash2->data('silence')->loaded, undef, 'didn\'t load music_hash2 silence');

$music_hash2->load;
is($music_hash2->data('sample') ->loaded, $mix_sample,  'loaded music_hash2 sample is the same as in music_hash');
is($music_hash2->data('silence')->loaded, $mix_silence, 'loaded music_hash2 silence is the same as in music_hash');
is($music_hash2->data('tribe_i')->loaded, $mix_tribe_i, 'loaded music_hash2 tribe_i is the same as in music_hash');

$music_hash2->unload('sample', $music_hash2->data('silence'));
is($music_hash2->data('sample') ->loaded, undef, 'unloaded music_hash2 sample with name');
is($music_hash2->data('silence')->loaded, undef, 'unloaded music_hash2 silence with data');
isa_ok($music_hash2->data('tribe_i')->loaded, 'SDL::Mixer::MixMusic', 'didn\'t unload music_hash2 tribe_i');
$music_hash2->load;

$music_hash2->unload('silence', $music_hash2->data('tribe_i'));
is($music_hash2->data('silence')->loaded, undef, 'unloaded music_hash2 silence with name');
is($music_hash2->data('tribe_i')->loaded, undef, 'unloaded music_hash2 tribe_i with data');
isa_ok($music_hash2->data('sample')->loaded, 'SDL::Mixer::MixMusic', 'didn\'t unload music_hash2 sample');
$music_hash2->load;

SDLx::Music->unload($music_hash2->data('tribe_i'), $music_hash2->data('sample'));
is($music_hash2->data('sample') ->loaded, undef, 'unloaded music_hash2 sample with class');
is($music_hash2->data('tribe_i')->loaded, undef, 'unloaded music_hash2 tribe_i with class');
isa_ok($music_hash2->data('silence')->loaded, 'SDL::Mixer::MixMusic', 'didn\'t unload music_hash2 silence');

my $new_mix_sample = SDL::Mixer::load_MUS('test/data/sample.wav');
isnt($new_mix_sample, $mix_sample, 'the mix_sample objects are different');
$music_hash2->data('sample')->loaded($new_mix_sample);
is($music_hash2->data('sample')->loaded, $new_mix_sample, 'loaded has been changed to new_mix_sample');
weaken($new_mix_sample);

$music_hash2->load('sample');
is($music_hash2->data('sample')->loaded, $new_mix_sample, 'still the same after load name');
$music_hash2->load($music_hash2->data('sample'));
is($music_hash2->data('sample')->loaded, $new_mix_sample, 'still the same after load object');
SDLx::Music->load($music_hash2->data('sample'));
is($music_hash2->data('sample')->loaded, $new_mix_sample, 'still the same after load class object');

$music_hash2->data('sample')->loaded(undef);
is($new_mix_sample, undef, 'new mix music sample destroyed');
$music_hash2->load;
is($music_hash2->data('sample')->loaded, $mix_sample, 'back to the old mix sample object');

$music_hash->unload;
$music_hash2->unload;
is($mix_sample,  undef, 'mix music sample destroyed');
is($mix_silence, undef, 'mix music silence destroyed');
is($mix_tribe_i, undef, 'mix music tribe_i destroyed');

is($music_hash->last_played, undef, 'No last played with class');
is(SDLx::Music->last_played, undef, 'No last played with object');
is($music_hash->playing,     undef, 'Not playing with class');
is(SDLx::Music->playing,     undef, 'Not playing with object');
is($music_hash->paused,      undef, 'Not paused with class');
is(SDLx::Music->paused,      undef, 'Not paused with object');
is($music_hash->fading,      0,     'Not fading with class');
is(SDLx::Music->fading,      0,     'Not fading with object');

$music_hash->play('silence');
is($music_hash->last_played, $music_hash->data('silence'), 'No last played with class');
is(SDLx::Music->last_played, $music_hash->data('silence'), 'No last played with object');
is($music_hash->playing,     $music_hash->data('silence'), 'Not playing with class');
is(SDLx::Music->playing,     $music_hash->data('silence'), 'Not playing with object');
is($music_hash->paused,      undef,                        'Not paused with class');
is(SDLx::Music->paused,      undef,                        'Not paused with object');
is($music_hash->fading,      0,                            'Not fading with class');
is(SDLx::Music->fading,      0,                            'Not fading with object');

$music_hash->pause;
is($music_hash->last_played, $music_hash->data('silence'), 'No last played with class');
is(SDLx::Music->last_played, $music_hash->data('silence'), 'No last played with object');
is($music_hash->playing,     $music_hash->data('silence'), 'Not playing with class');
is(SDLx::Music->playing,     $music_hash->data('silence'), 'Not playing with object');
is($music_hash->paused,      $music_hash->data('silence'), 'Not paused with class');
is(SDLx::Music->paused,      $music_hash->data('silence'), 'Not paused with object');
is($music_hash->fading,      0,                            'Not fading with class');
is(SDLx::Music->fading,      0,                            'Not fading with object');

$music_hash->stop;
is($music_hash->last_played, $music_hash->data('silence'), 'No last played with class');
is(SDLx::Music->last_played, $music_hash->data('silence'), 'No last played with object');
is($music_hash->playing,     undef,                        'Not playing with class');
is(SDLx::Music->playing,     undef,                        'Not playing with object');
is($music_hash->paused,      undef,                        'Not paused with class');
is(SDLx::Music->paused,      undef,                        'Not paused with object');
is($music_hash->fading,      0,                            'Not fading with class');
is(SDLx::Music->fading,      0,                            'Not fading with object');

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}

done_testing();

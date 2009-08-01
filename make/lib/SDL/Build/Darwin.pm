package SDL::Build::Darwin;

use base 'SDL::Build';

sub fetch_includes
{
	return (
	'/usr/local/include/SDL'   => '/usr/local/lib',
	'/usr/local/include'       => '/usr/local/lib',
	'/usr/local/include/smpeg' => '/usr/local/lib',
	'/usr/include/SDL'         => '/usr/lib',
	'/usr/include'             => '/usr/lib',
	'/usr/include/smpeg'       => '/usr/lib',
	'/usr/local/include/GL'    => '/usr/local/lib',
	'/usr/local/include/gl'    => '/usr/local/lib',
	'/usr/include/GL'          => '/usr/lib', 
	'/usr/include/gl'          => '/usr/lib', 

	'/System/Library/Frameworks/SDL_mixer.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/SDL_image.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/SDL_ttf.framework/Headers'       => '../../lib',
	'/System/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
	'/System/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/libvorbisfile.framework/Headers' => '../../lib',
	'/System/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
	'../../include'                                              => '../../lib',
	'/System/Library/Frameworks/OpenGL.framework/Headers'        =>
		'/System/Library/Frameworks/OpenGL.framework/Libraries',
	);
}

1;

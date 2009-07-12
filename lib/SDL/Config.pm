package SDL::Config;

my $sdl_config; 
$sdl_config = {
                'OpenGL' => {
                              'GL' => [
                                        '/System/Library/Frameworks/OpenGL.framework/Headers',
                                        '/System/Library/Frameworks/OpenGL.framework/Libraries'
                                      ],
                              'SDL' => 0,
                              'GLU' => [
                                         '/System/Library/Frameworks/OpenGL.framework/Headers',
                                         '/System/Library/Frameworks/OpenGL.framework/Libraries'
                                       ]
                            },
                'SDL' => {
                           'png' => 0,
                           'SDL' => 0,
                           'SDL_ttf' => 0,
                           'SDL_svg' => 0,
                           'SDL_net' => 0,
                           'SDL_image' => 0,
                           'jpeg' => 0,
                           'SDL_gfx' => 0,
                           'smpeg' => 0,
                           'SDL_sound' => 0,
                           'SDL_mixer' => 0
                         },
                'SFont' => {
                             'SDL_image' => 0,
                             'SDL' => 0
                           }
              };

sub has
{
	my ($class, $define) = @_;
	scalar grep { $$sdl_config{$_}{$define} } keys %$sdl_config;
}

1;

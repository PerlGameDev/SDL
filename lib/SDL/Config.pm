package SDL::Config;

my $sdl_config; 
$sdl_config = {
                'OpenGL' => {
                              'GL' => [
                                        '/System/Library/Frameworks/OpenGL.framework/Headers',
                                        '/System/Library/Frameworks/OpenGL.framework/Libraries'
                                      ],
                              'SDL' => [
                                         '/opt/local/include/SDL',
                                         '/opt/local/lib'
                                       ],
                              'GLU' => [
                                         '/System/Library/Frameworks/OpenGL.framework/Headers',
                                         '/System/Library/Frameworks/OpenGL.framework/Libraries'
                                       ]
                            },
                'SDL' => {
                           'png' => [
                                      '/opt/local/include',
                                      '/opt/local/lib'
                                    ],
                           'SDL' => [
                                      '/opt/local/include/SDL',
                                      '/opt/local/lib'
                                    ],
                           'SDL_ttf' => [
                                          '/opt/local/include/SDL',
                                          '/opt/local/lib'
                                        ],
                           'SDL_net' => [
                                          '/opt/local/include/SDL',
                                          '/opt/local/lib'
                                        ],
                           'SDL_image' => [
                                            '/opt/local/include/SDL',
                                            '/opt/local/lib'
                                          ],
                           'SDL_gfx' => [
                                          '/opt/local/include/SDL',
                                          '/opt/local/lib'
                                        ],
                           'jpeg' => [
                                       '/opt/local/include',
                                       '/opt/local/lib'
                                     ],
                           'smpeg' => 0,
                           'SDL_mixer' => [
                                            '/opt/local/include/SDL',
                                            '/opt/local/lib'
                                          ]
                         },
                'SFont' => {
                             'SDL_image' => [
                                              '/opt/local/include/SDL',
                                              '/opt/local/lib'
                                            ],
                             'SDL' => [
                                        '/opt/local/include/SDL',
                                        '/opt/local/lib'
                                      ]
                           }
              };

sub has
{
	my ($class, $define) = @_;
	scalar grep { $$sdl_config{$_}{$define} } keys %$sdl_config;
}

1;

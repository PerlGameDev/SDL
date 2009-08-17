package SDL::Config;

my $sdl_config; 
$sdl_config = {
                'OpenGL' => {
                              'GL' => [
                                        '/usr/include/GL',
                                        '/usr/lib'
                                      ],
                              'SDL' => [
                                         '/usr/include/SDL',
                                         '/usr/lib'
                                       ],
                              'GLU' => [
                                         '/usr/include/GL',
                                         '/usr/lib'
                                       ]
                            },
                'SDL' => {
                           'png' => [
                                      '/usr/include',
                                      '/usr/lib'
                                    ],
                           'SDL' => [
                                      '/usr/include/SDL',
                                      '/usr/lib'
                                    ],
                           'SDL_ttf' => [
                                          '/usr/include/SDL',
                                          '/usr/lib'
                                        ],
                           'SDL_net' => [
                                          '/usr/include/SDL',
                                          '/usr/lib'
                                        ],
                           'SDL_image' => [
                                            '/usr/include/SDL',
                                            '/usr/lib'
                                          ],
                           'SDL_gfx' => [
                                          '/usr/include/SDL',
                                          '/usr/lib'
                                        ],
                           'jpeg' => [
                                       '/usr/include',
                                       '/usr/lib'
                                     ],
                           'smpeg' => [
                                        '/usr/include/smpeg',
                                        '/usr/lib'
                                      ],
                           'SDL_mixer' => [
                                            '/usr/include/SDL',
                                            '/usr/lib'
                                          ]
                         },
                'SFont' => {
                             'SDL_image' => [
                                              '/usr/include/SDL',
                                              '/usr/lib'
                                            ],
                             'SDL' => [
                                        '/usr/include/SDL',
                                        '/usr/lib'
                                      ]
                           }
              };

sub has
{
	my ($class, $define) = @_;
	scalar grep { $$sdl_config{$_}{$define} } keys %$sdl_config;
}

1;

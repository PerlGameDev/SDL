use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new
    ( module_name     => 'SDL::Rect',
      license         => 'perl',
     	build_requires       =>
	{
		'Test::Simple' => '0.47',
		'Module::Build' => '0.22',
		'YAML'	=> '0.68',
		'Alien::SDL'    => '0.02',
		'ExtUtils::CBuilder' => '0.260301'
	},
	build_recommends     =>
	{
		'Pod::ToDemo'  => '0.20'		
	},
	xs_files             => {'Rect.xs' => './Rect.xs'},
	extra_compiler_flags => scalar `sdl-config --cflags`,
	extra_linker_flags  =>  scalar `sdl-config --libs`,
	dist_author	     => 'Kartik Thakore <KTHAKORE@cpan.org>',

    )->create_build_script;

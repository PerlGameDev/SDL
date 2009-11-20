use Module::Build;
# See perldoc Module::Build for details of how this works

my $build = Module::Build->new
(
	module_name  => 'SDL::Tutorial::MoP',
	bmp_files    => 
	{
		'data/tiles.bmp' => 'lib/auto/SDL/Tutorial/MoP/data/tiles.bmp',
		'data/main.bmp'  => 'lib/auto/SDL/Tutorial/MoP/data/main.bmp',
	},
	map_files    => 
	{
		'data/main.map' => 'lib/auto/SDL/Tutorial/MoP/data/main.map',
	},
	install_path => 
	{
		bmp => 'installsitelib',
		map => 'installsitelib',
	}, 
);
$build->add_build_element('bmp');
$build->add_build_element('map');
$build->create_build_script;

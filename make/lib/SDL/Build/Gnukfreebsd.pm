package SDL::Build::Gnukfreebsd;

use base 'SDL::Build';

sub fetch_includes
{
	return (
	'/usr/local/include'       => '/usr/local/lib',
	'/usr/local/include/gl'    => '/usr/local/lib',
	'/usr/local/include/GL'    => '/usr/local/lib',
	'/usr/local/include/SDL'   => '/usr/local/lib',
	'/usr/local/include/smpeg' => '/usr/local/lib',

	'/usr/include'              => '/usr/lib',
	'/usr/include/gl'           => '/usr/lib',
	'/usr/include/GL'           => '/usr/lib',
	'/usr/include/SDL'          => '/usr/lib',
	'/usr/include/smpeg'        => '/usr/lib',

	'/usr/X11R6/include'        => '/usr/X11R6/lib',
	'/usr/X11R6/include/gl'     => '/usr/X11R6/lib',
	'/usr/X11R6/include/GL'     => '/usr/X11R6/lib',
	);
}

1;

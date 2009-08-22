package SDL::Build::Openbsd;

use base 'SDL::Build';
# /usr/local
sub fetch_includes
{
	return (
	'/usr/local/include',        => '/usr/local/lib',
	'/usr/local/include/libpng'     => '/usr/local/lib',
	'/usr/local/include/GL'     => '/usr/local/lib',
	'/usr/local/include/SDL'     => '/usr/local/lib',
	'/usr/local/include/smpeg'   => '/usr/local/lib',

	'/usr/include'              => '/usr/lib',

	'/usr/X11R6/include'        => '/usr/X11R6/lib',
	'/usr/X11R6/include/GL'     => '/usr/X11R6/lib',
	);
}

1;

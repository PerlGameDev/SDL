package SDL::Build::Cygwin;

use base 'SDL::Build';

sub opengl_headers
{
	return GL => 'SDL_opengl.h';
}

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

sub build_links
{
	my $self  = shift;
	my $links = $self->SUPER::build_links();

	for my $subsystem (values %$links)
	{
		push @{ $subsystem{ libs } }, '-lpthreads';
	}

	return $links;
}

1;

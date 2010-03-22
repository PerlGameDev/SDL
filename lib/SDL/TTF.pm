package SDL::TTF;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::TTF;

use base 'Exporter';

our @EXPORT_OK = qw(
	TTF_HINTING_NORMAL
	TTF_HINTING_LIGHT
	TTF_HINTING_MONO
	TTF_HINTING_NONE
	TTF_STYLE_NORMAL
	TTF_STYLE_BOLD
	TTF_STYLE_ITALIC
	TTF_STYLE_UNDERLINE
	TTF_STYLE_STRIKETHROUGH
);

our %EXPORT_TAGS = 
(
	hinting => [qw(
		TTF_HINTING_NORMAL
		TTF_HINTING_LIGHT
		TTF_HINTING_MONO
		TTF_HINTING_NONE
	)],
	style => [qw(
		TTF_STYLE_NORMAL
		TTF_STYLE_BOLD
		TTF_STYLE_ITALIC
		TTF_STYLE_UNDERLINE
		TTF_STYLE_STRIKETHROUGH
	)]
);

use constant{
	TTF_HINTING_NORMAL      => 0,
	TTF_HINTING_LIGHT       => 1,
	TTF_HINTING_MONO        => 2,
	TTF_HINTING_NONE        => 3,
	TTF_STYLE_NORMAL        => 0,
	TTF_STYLE_BOLD          => 1,
	TTF_STYLE_ITALIC        => 2,
	TTF_STYLE_UNDERLINE     => 4,
	TTF_STYLE_STRIKETHROUGH => 8,
};

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;

#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my %ttf_consts =
(
TTF_MAJOR_VERSION => 2,
TTF_MINOR_VERSION => 0,
TTF_PATCHLEVEL    => 10,
UNICODE_BOM_NATIVE => 0xFEFF,
UNICODE_BOM_SWAPPED => 0xFFFE,
TTF_STYLE_NORMAL => 0x00,
TTF_STYLE_BOLD => 0x01,
TTF_STYLE_ITALIC => 0x02,
TTF_STYLE_UNDERLINE => 0x04,
TTF_STYLE_STRIKETHROUGH => 0x08,
TTF_HINTING_NORMAL => 0,
TTF_HINTING_LIGHT => 0,
TTF_HINTING_MONO => 0,
TTF_HINTING_NONE => 0,
);


TODO:
{
    local $TODO = "Not implemented";
	while ( my ($key, $value) = each %ttf_consts )
	{
	    fail "Not Implmented $key as $value";
    	}
}

done_testing;

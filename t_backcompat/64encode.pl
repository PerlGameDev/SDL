#!/usr/bin/perl

use MIME::Base64 qw/ encode_base64 /;

open FILE, "< $ARGV[0]" or die "$!\n";

while (read FILE, $buf, 60*57) {
	print encode_base64($buf);
}

#!perl
#
die "Usage: username password architecture [extra options for smolder_smoke_signal]. \n Found @ARGV args" if $#ARGV < 2;
system split ' ', 'prove -l -b --archive sdl.tar.gz';
system split ' ', "tools/smolder_smoke_signal smolder_smoke_signal --server sdlperl.ath.cx:8080  --username $ARGV[0] --password $ARGV[1] --file sdl.tar.gz --project SDL --architecture $ARGV[2] $ARGV[3]";

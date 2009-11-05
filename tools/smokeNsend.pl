#!perl
#
die "Usage: username password [git-branch] [extra options for smolder_smoke_signal]. \n Found @ARGV args" if $#ARGV < 1;
system split ' ', "git pull origin $ARGV[2]" if $ARGV[2];
system( 'perl',  'Build.PL');
system( 'perl', 'Build');
system split ' ', 'prove -l -b --merge --archive sdl.tar.gz';
system split ' ', "perl tools/smolder_smoke_signal --server sdlperl.ath.cx:8080  --username $ARGV[0] --password $ARGV[1] --file sdl.tar.gz --project SDL --architecture $] --platform $^O $ARGV[3]";

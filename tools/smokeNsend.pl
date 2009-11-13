#!perl
#
die "Usage: username password [git-branch] [toggle for main repo] [extra options for smolder_smoke_signal]. \n Found @ARGV args" if $#ARGV < 1;
system split ' ', "git pull origin $ARGV[2]" if ( $ARGV[2] && !($ARGV[3]));
system split ' ', "git pull git://github.com/kthakore/SDL_perl.git $ARGV[2]" if $ARGV[3];
my $revision =  `git log  --pretty='%h' -n 1`;
system( 'perl',  'Build.PL');
system( 'perl', 'Build');
system split ' ', 'prove -vlbm --archive sdl.tar.gz';
system split ' ', "perl tools/smolder_smoke_signal --server sdlperl.ath.cx --port 8080  --username $ARGV[0] --password $ARGV[1] --file sdl.tar.gz --project SDL --architecture $] --platform $^O $ARGV[3] --revision $revision";

=pod

=head1 NAME

SDL perl packager - Package SDL games

=head1 SETUP

 cpan Alien::SDL SDL

 cpan Module::ScanDeps 

version 0.97 needed

 cpan PAR::Packer 

version 1.004 needed

pip http://strawberryperl.com/package/kmx/perl-modules-patched/PAR-1.000_patched.tar.gz

=head1 USAGE

  perl SDLpp.pl --output=a.exe  --input=script.pl --nclude=./lib --more=Foo::Bar,Bar::Foo 

=head1 AUTHOR

kthakore 

=cut

use strict;
use warnings;
use SDL;
use Alien::SDL;
use Getopt::Long;
use File::Spec;
use File::Find qw/finddepth/;

use Data::Dumper;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );


#Checking if we have the pp installed
die 'Need PAR::Packer' if !( eval ' use PAR::Packer; 1');

#Default out put is a or a.exe for windows
my $output = 'a';
   $output .= '.exe' if $^O =~ /win32/ig ;

my $libs = 'SDL';

my $input;

my $Include = '';

my $extra = '';

my $result = GetOptions(
    "output=s"       => \$output,
    "libs=s"        => \$libs,
    "input=s"       => \$input,
    "nclude=s"     => \$Include,
    "more=s"	  => \$extra,
    "help"        => sub { usage() },
);

$extra ='-M '.$extra if $extra;
$extra =~ s/,/ \-M /g;

sub usage
{
  print " perl SDLpp.pl --output=a.exe --libs=SDL,SDL_main,SDL_gfx  --input=script.pl --nclude=./lib --more=Foo::Bar,Bar::Foo \n".
        " if --libs is not define all SDL libs are packaged \n";
  
  exit;
}



 if (! $input )
 {
        warn 'Input needs to be specified.';
        usage;
 }
 

print "BUILDING PAR \n";
my $exclude_modules  = '-X Alien::SDL::ConfigData -X SDL::ConfigData';
my $include_modules  = '-M ExtUtils::CBuilder::Base -M Data::Dumper -M SDL -M Alien::SDL';
   $include_modules .= " $extra" if $extra;

my $out_par = $output.'.par';
my $par_cmd = "pp -B $exclude_modules $include_modules";
   $par_cmd .= " -I $Include" if $Include;
   $par_cmd .= " -p -o $out_par $input";

 print "\t $par_cmd \n";

`$par_cmd` if ! -e $out_par;


print "PAR: $out_par\n" if -e $out_par;
   
print "SEARCHING FOR ConfigData files \n";
my $lib; my $AS_path; my $SD_path;

finddepth(\&wanted, @INC);
sub wanted {  
  
  if( $_ =~ /ConfigData/ )
  {
  $AS_path = $File::Find::name if $File::Find::name =~ 'Alien/SDL/ConfigData.pm';
  $SD_path = $File::Find::name if $File::Find::name =~ 'SDL/ConfigData.pm' && $File::Find::name !~ 'Alien/SDL/ConfigData.pm';
  
  $lib = $File::Find::dir if ($AS_path && $SD_path);
  }
}

die "Cannot find lib/SDL/ConfigData.pm or lib/Alien/SDL/ConfigData.pm \n" if ( !$AS_path || !$SD_path );

print "Found ConfigData files in $lib \n";

print "READING PAR FILE \n";

 my $par_file = Archive::Zip->new();
   unless ( $par_file->read( $out_par ) == AZ_OK ) {
       die 'read error on '.$out_par;
   }

$par_file->addFile( $AS_path, 'lib/Alien/SDL/ConfigData.pm');
$par_file->addFile( $SD_path, 'lib/SDL/ConfigData.pm');
 
my $share = Alien::SDL::ConfigData->config('share_subdir');

my @shares = $par_file->membersMatching($share);

my $alien_sdl_auto = $shares[0]->fileName;

$alien_sdl_auto =~ s/$share(\S+)// if $alien_sdl_auto;

print $alien_sdl_auto;
my @auto_folder = $par_file->membersMatching( "$alien_sdl_auto(?!$share)" );

my @sdl_not_runtime = $par_file->membersMatching( $share.'/include' ); #TODO remove extra fluff in share_dri
push @sdl_not_runtime, @auto_folder; #remove non share dir stuff 
push @sdl_not_runtime ,$par_file->membersMatching( $share.'/etc' );
push @sdl_not_runtime ,$par_file->membersMatching( $share.'/share' );
push @sdl_not_runtime ,$par_file->membersMatching( $share.'/lib' ) if $^O =~ /win32/ig;
push @sdl_not_runtime ,$par_file->membersMatching( $share.'/bin' ) unless $^O =~ /win32/ig;
print "REMOVING NON RUNTIME $#sdl_not_runtime files from  \n";

$par_file->removeMember($_) foreach @sdl_not_runtime;


my @config_members = $par_file->membersMatching( 'ConfigData.pm' );

foreach( @config_members )
{
   $_->desiredCompressionLevel( 1 );
   $_->unixFileAttributes(0644); 
}



unlink $out_par.'2';
 unless ( $par_file->writeToFileNamed($out_par.'2') == AZ_OK ) {
       die 'write error';
   }
   

$par_cmd = "pp -o $output ".$out_par."2";

`$par_cmd`;

print "MADE $output \n" if -e $output;
unlink $out_par.'2';
unlink $out_par;

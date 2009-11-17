@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" --build_bat %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 --build_bat %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!perl
#line 15

use strict;
use Cwd;
use File::Basename;
use File::Spec;

sub magic_number_matches {
  return 0 unless -e '_build\\magicnum';
  local *FH;
  open FH, '_build\\magicnum' or return 0;
  my $filenum = <FH>;
  close FH;
  return $filenum == 1647;
}

my $progname;
my $orig_dir;
BEGIN {
  $^W = 1;  # Use warnings
  $progname = basename($0);
  $orig_dir = Cwd::cwd();
  my $base_dir = 'C:\\SDL_PERL\\EXAMPLES\\MOP';
  if (!magic_number_matches()) {
    unless (chdir($base_dir)) {
      die ("Couldn't chdir($base_dir), aborting\n");
    }
    unless (magic_number_matches()) {
      die ("Configuration seems to be out of date, please re-run 'perl Build.PL' again.\n");
    }
  }
  unshift @INC,
    (

    );
}

close(*DATA) unless eof(*DATA); # ensure no open handles to this script

use Module::Build;

# Some platforms have problems setting $^X in shebang contexts, fix it up here
$^X = Module::Build->find_perl_interpreter;

if (-e 'Build.PL' and not Module::Build->up_to_date('Build.PL', $progname)) {
   warn "Warning: Build.PL has been altered.  You may need to run 'perl Build.PL' again.\n";
}

# This should have just enough arguments to be able to bootstrap the rest.
my $build = Module::Build->resume (
  properties => {
    config_dir => '_build',
    orig_dir => $orig_dir,
  },
);

$build->dispatch;

__END__
:endofperl

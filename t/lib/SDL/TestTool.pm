use strict;
use warnings;
use vars qw/$VERSION @ISA @EXPORT_OK %EXPORT_TAGS $CarpLevel/;
use Exporter;
use Carp qw/croak/;
@ISA = 'Exporter';
@EXPORT_OK = qw/capture test_init/;
%EXPORT_TAGS = (all => \@EXPORT_OK);


use lib '../../../'; #../../../t/lib/SDL 
use SDL; 

###CREDITS GOES TO DAVID GOLDEN FOR THE FOLLOWING CODE
### http://search.cpan.org/dist/IO-CaptureOutput/lib/IO/CaptureOutput.pod
### We stole it as we only need capture an nothing more from that awesome module
sub _capture (&@) { ## no critic
    my ($code, $output, $error, $output_file, $error_file) = @_;

    # check for valid combinations of input
    {
      local $Carp::CarpLevel = 1;
      my $error = _validate($output, $error, $output_file, $error_file);
      croak $error if $error;
    }

    # if either $output or $error are defined, then we need a variable for 
    # results; otherwise we only capture to files and don't waste memory
    if ( defined $output || defined $error ) {
      for ($output, $error) {
          $_ = \do { my $s; $s = ''} unless ref $_;
          $$_ = '' if $_ != \undef && !defined($$_);
      }
    }

    # merge if same refs for $output and $error or if both are undef -- 
    # i.e. capture \&foo, undef, undef, $merged_file
    # this means capturing into separate files *requires* at least one
    # capture variable
    my $should_merge = 
      (defined $error && defined $output && $output == $error) || 
      ( !defined $output && !defined $error ) || 
      0;

    my ($capture_out, $capture_err);

    # undef means capture anonymously; anything other than \undef means 
    # capture to that ref; \undef means skip capture
    if ( !defined $output || $output != \undef ) { 
        $capture_out = IO::CaptureOutput::_proxy->new(
            'STDOUT', $output, undef, $output_file
        );
    }
    if ( !defined $error || $error != \undef ) { 
        $capture_err = IO::CaptureOutput::_proxy->new(
            'STDERR', $error, ($should_merge ? 'STDOUT' : undef), $error_file
        );
    }

    # now that output capture is setup, call the subroutine
    # results get read when IO::CaptureOutput::_proxy objects go out of scope
    &$code();
}

# Extra indirection for symmetry with capture_exec, etc.  Gets error reporting
# to the right level
sub capture (&@) { ## no critic
    return &_capture; 
}


sub test_init
{
   
}

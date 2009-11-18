package SDL::Tutorial::MoP;
use strict;
use SDL::Tutorial::MoP::EventManager;
use SDL::Tutorial::MoP::Base;
use SDL::Tutorial::MoP::View;
use SDL::Tutorial::MoP::Controller::Keyboard;
use SDL::Tutorial::MoP::Controller::CPUSpinner;
use SDL::Tutorial::MoP::Controller::Game;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}


#################### subroutine header begin ####################

=head2 sample_function

 Usage     : How to use this function/method
 Purpose   : What it does
 Returns   : What it returns
 Argument  : What it wants to know
 Throws    : Exceptions and other anomolies
 Comment   : This is a sample subroutine header.
           : It is polite to include more pod and fewer comments.

See Also   : 

=cut

#################### subroutine header end ####################

sub new
{
	my ($class, %parameters) = @_;

	my $self = bless ({}, ref ($class) || $class);

	return $self;
}

sub play
{
    my ($class, $EDEBUG, $KEYDEBUG, $GDEBUG, $FPS) = @_;

    my $keybd    = SDL::Tutorial::MoP::Controller::Keyboard->new();
    my $spinner  = SDL::Tutorial::MoP::Controller::CPUSpinner->new();
    my $gameView = SDL::Tutorial::MoP::View::Game->new();

    my $game     = SDL::Tutorial::MoP::Controller::Game->new(
        EDEBUG      => ${EDEBUG},
        GDEBUG      => ${GDEBUG},
        KEYDEBUG    => ${KEYDEBUG},
        FPS         => $FPS,
    );

    $spinner->run;
}

SDL::Tutorial::MoP->play(@ARGV) unless caller;

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

SDL::Tutorial::MoP - Scrolling Game in SDL Perl 

=head1 SYNOPSIS

  use SDL::Tutorial::MoP;
  blah blah blah


=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.


=head1 USAGE



=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    Kartik Thakore
    CPAN ID: KTHAKORE
    none
    kthakore@CPAN.org
    http://yapgh.blogspot.com

=head1 COPYRIGHT

This program is free software licensed under the...

	The General Public License (GPL)
	Version 2, June 1991

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################

1;
# The preceding line will help the module return a true value


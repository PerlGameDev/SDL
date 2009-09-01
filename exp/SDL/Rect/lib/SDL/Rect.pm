package SDL::Rect;
use strict;


    use vars qw($VERSION @ISA);
    $VERSION     = '0.01';
    require DynaLoader;
    @ISA = qw(DynaLoader);
    
    
   


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
	my $self = shift;
	my ($x, $y, $w, $h) = @_;
	$self = \SDL::Rect::NewRect($x, $y, $w, $h);

	return $self;
}

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

SDL::Rect - Bindings to rect obj and its functions in the C SDL libs

=head1 SYNOPSIS

  use SDL::Rect;
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
    KTHAKORE@CPAN.ORG
    http://yapgh.blogspot.com/

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################

bootstrap SDL::Rect; 
1;
# The preceding line will help the module return a true value


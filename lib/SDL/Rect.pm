=pod
=cut
package SDL::Rect;
use strict;
use warnings;
require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
bootstrap SDL::Rect;

=head1 Perl binding to C stuct Rect
=cut

# Preloaded methods go here.

# TODO: mangle with the symbol table to create an alias
# to sub x. We could call x from inside the sub but that
# would be another call and rects are a time-critical object.
sub left {
	my $self = shift;
	RectX($self,@_);
}

sub x {
	my $self = shift;
	RectX($self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub y)
sub top {
	my $self = shift;
	RectY($self,@_);
}

sub y {
	my $self = shift;
	RectY($self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub width)
sub w {
	my $self = shift;
	RectW($self,@_);
}

sub width {
	my $self = shift;
	RectW($self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub height)
sub h {
	my $self = shift;
	RectH($self,@_);
}

sub height {
	my $self = shift;
	RectH($self,@_);
}


# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__

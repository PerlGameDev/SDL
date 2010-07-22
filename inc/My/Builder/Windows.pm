package My::Builder::Windows;
use base 'My::Builder';

sub process_xs {
    my ( $self, $file ) = @_;

    $file =~ s/\\/\//g;

    $self->SUPER::process_xs($file);
}

1;

package SDLx::Color;
use strict;
use SDL::Color;
use Carp;
use base 'SDL::Color';
use overload
'@{}' => "_array",
fallback => 1,
;

sub new {
	my ($class, @args) = @_;
	if(ref $args[0] eq "HASH") {
		my %options = %{$args[0]};
		my $alpha = (defined $options{alpha} ? $options{alpha} : $options{a});
		Carp::carp("Extra arguments are not taken when hash is specified") if @args > 1;
		if(ref $options{color} eq "ARRAY" or ref $options{c} eq "ARRAY") {
			@args = ((ref $options{color} eq "ARRAY" ? $options{color} : $options{c}), $alpha);
		}
		elsif(defined $options{rgb}) {
			@args = ($options{rgb}, $alpha);
		}
		elsif(defined $options{rgba}) {
			@args = ($options{rgba});
		}
		else {
			@args = (0, $alpha);
		}
	}
	my (@rgba);
	if(@args > 2) {
		@rgba = @args;
	}
	elsif(ref $args[0] eq "ARRAY") {
		(@rgba) = (@{$args[0]}[0..2], (defined $args[1] ? $args[1] : ${$args[0]}[3]));
	}
	elsif(!ref $args[0]) {
		if(@args == 2) {
			@rgba = (
				$args[0] >> 16 & 255,
				$args[0] >> 8 & 255,
				$args[0] & 255,
				$args[1]
			);
		}
		elsif(@args == 1) {
			@rgba = (
				$args[0] >> 32 & 255,
				$args[0] >> 16 & 255,
				$args[0] >> 8 & 255,
				$args[0] & 255
			);
		}
	}
	if(!@rgba) {
		Carp::croak("I don't understand!");
	}
	if($rgba[3] =~ s/%$//) {
		$rgba[3] = $rgba[3] / 100 * 255;
	}
	@rgba = map {
		my $n = int(ref() ? 0 : $_);
		$n < 0 ? 0 : $n > 255 ? 255 : $n;
	} @rgba;


	#What do with alpha?????
	my $self = $class->SUPER::new( @rgba[0..2] );
	unless ($$self) {
		#require Carp;
		croak SDL::get_error();

	}
	bless $self, $class;
	$self->{a} = 255 ;
	$self->{a} = $rgba[3] if $rgba[3];


	return $self;
}
sub rgb {
	my ($self) = @_;
	sprintf "0x" . "%02x" x 3, $self->r, $self->g, $self->b;

}

sub a :lvalue
{
	return $_[0]->{a};
}

sub rgba {
	my ($self) = @_;
	$self->rgb . sprintf "%02x", $self->a;
}
sub _array {
	my ($self) = @_;
	[$self->r, $self->g, $self->b, $self->a];
}


1;

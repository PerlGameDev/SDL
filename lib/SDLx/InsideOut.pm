package SDLx::InsideOut;
use strict;
use warnings;

use Hash::Util::FieldHash ();

Hash::Util::FieldHash::idhash( our %_ );
# I have written a speed test, and idhashes are more than twice as fast as normal hashes
# however, idhashes are about half as fast as our current implementation
# I have attached the test below so you can check that it's right

sub _register {
	my $self = shift;
	Hash::Util::FieldHash::register( $self, \%_ );
	$_{ $self } = { @_ };
}

use overload
	'%{}' => sub { $_{ $_[0] } },
	fallback => 1,
;

1;

__END__
use strict;
use warnings;
use Hash::Util::FieldHash ':all';
use Scalar::Util 'refaddr';
use Time::HiRes 'time';

idhash my %idhash;
my %hash;
my %current;
my %idcurrent;
my @dummy;
my $time;

{
	package Current;
	sub DESTROY {
		my ($self) = @_;
		delete $current{ ::refaddr $self };
	}
}
{
	package IDCurrent;
	sub DESTROY {
		my ($self) = @_;
		delete $idcurrent{ ::id $self };
	}
}

$time = time;
for(0..$ARGV[0]) {
	my $o = bless \my $d, 'IDHash';
	register $o, \%idhash;
	$idhash{$o} = 1;
	my $dummy = $idhash{$o};
	push @dummy, $o;
}
undef @dummy;
undef %idhash;
warn "idhash took: ", time - $time;


$time = time;
for(0..$ARGV[0]) {
	my $o = bless \my $d, 'Hash';
	register $o, \%hash;
	$hash{id $o} = 1;
	my $dummy = $hash{id $o};
	push @dummy, $o;
}
undef @dummy;
undef %hash;
warn "normal hash with register took: ", time - $time;


$time = time;
for(0..$ARGV[0]) {
	my $o = bless \my $d, 'Current';
	$current{refaddr $o} = 1;
	my $dummy = $hash{refaddr $o};
	push @dummy, $o;
}
undef @dummy;
undef %hash;
warn "current implementation took: ", time - $time;


$time = time;
for(0..$ARGV[0]) {
	my $o = bless \my $d, 'IDCurrent';
	$current{id $o} = 1;
	my $dummy = $hash{id $o};
	push @dummy, $o;
}
undef @dummy;
undef %hash;
warn "current implementation with id instead of refaddr took: ", time - $time;

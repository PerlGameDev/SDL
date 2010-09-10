package MouseImgur;

# Imgur.pm
# simple perl module for uploading pics to imgur.com

use MIME::Base64;
use LWP;
use strict;
use warnings;
use Mouse; # a use Mouse instead

has 'key' => ( is => 'rw', isa => 'Str' );

# errors:
# 0 -- no api key
# -1 -- problem with the file
sub upload {
	my $self       = shift;
	my $image_path = shift;
	return 0 unless ( $self->key );
	my $res;
	if ( $image_path =~ /http:\/\// ) {
		$res = $image_path;
	} else {
		my $fh;
		open $fh, "<", $image_path or return -1;
		$res = _read_file($image_path);
	}
	$res = $self->_upload($res);
	return $res;
}


# base64'd image
sub _read_file {
	my $fname = shift;
	my $fh;
	open $fh, "<", $fname or return -1;
	binmode $fh;
	return encode_base64( join( "" => <$fh> ) );
}

# errors:
# 1000 	 No image selected
# 1001 	Image failed to upload
# 1002 	Image larger than 10MB
# 1003 	Invalid image type or URL
# 1004 	Invalid API Key
# 1005 	Upload failed during process
# 1006 	Upload failed during the copy process
# 1007 	Upload failed during thumbnail process
sub _upload {
	my $self  = shift;
	my $image = shift;
	return undef unless ($image);
	my $user_a = LWP::UserAgent->new( agent => "Perl" );
	my $res = $user_a->post( 'http://imgur.com/api/upload.xml', [ 'image' => $image, 'key' => $self->key ] );
	if ( $res->content =~ /<original_image>(.*?)<\/original_image>/ ) {
		return $1;
	} elsif ( $res->content =~ /<error_code>(\d+)<\/error_code>/ ) {
		return $1;
	} else {
		return -3;
	}
}


use warnings;
use strict;

package SDLBot;
use threads;
use threads::shared;
use Data::Dumper;
use LWP::UserAgent;
use LWP::Simple;
use Safe;

use SDL;
use SDLx::Surface;

use base qw( Bot::BasicBot );
my $old_count = 0;
my $quite     = 0;

warn Dumper qx(sh -c "ulimit -a");

sub said {
	my ( $self, $message ) = @_;
	if ( $message->{body} =~ /^eval:\s*/ ) {

		$message->{body} =~ s/^.+?eval://;
		warn 'Got ' . $message->{body};
		return eval_imgur( $message->{body} );

	}
	my $return = ticket($message);
	return $return if $return;



}

SDLBot->new(
	server   => 'irc.perl.org',
	channels => ['#sdl'],
	nick     => 'SDLevalbot',
)->run();


sub ticket {
	my $message = shift;
	if ( $message->{body} =~ /(TT)(\d+)/ ) {
		return "Ticket $2 is at http://sdlperl.ath.cx/projects/SDLPerl/ticket/$2";
	}


}

sub eval_imgur {

	warn 'eval';

	return "Can't run $_[0]" if $_[0] =~ /fork|unlink|threads|while/;

	my $videodriver = $ENV{SDL_VIDEODRIVER};
	$ENV{SDL_VIDEODRIVER} = 'dummy';

	my $key = '26447813009ded6a7e83986738085949';

	my $imgur = MouseImgur->new( key => $key );

	my $app = SDLx::Surface->new( width => 200, height => 200 );

	my $e = eval $_[0];

	warn 'Got eval: ' . $@;

	if ($@) {

		$e = $@;
		$e .= SDL::get_error();
		return $e;
	}
	my $image = 'foo' . rand(1000) . '.bmp';

	SDL::Video::save_BMP( $app, $image );

	my $result = $imgur->upload($image);

	my $r = "Imgur Upload: $result\n";

	unlink $image;

	$ENV{SDL_VIDEODRIVER} = $videodriver;


	return $r;

}



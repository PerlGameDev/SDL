use SDL;
use SDLx::Music;
$music = SDLx::Music->new;
$music->data( sam => "test/data/sample.wav" );
$sam = $music->data("sam");
$music->play($sam);
while ( $music->playing ) { print "playing\n"; sleep 1; }

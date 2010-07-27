use warnings;
use strict;

package SDLBot;
use threads;
use threads::shared;
use LWP::UserAgent;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use base qw( Bot::BasicBot );
my $old_count = 0;
my $quite = 0;
sub said
{
  my ($self, $message) = @_;
 if( $message =~ /rss_t/)
 {
   if( $quite == 1)
    {
	$quite = 0;
	return  'RSS feed toggled on' ;
    }
   if( $quite == 0)
    {
	$quite = 1;
	return  'RSS feed toggled off' ;
    }

 }
   my $return = ticket($message);
   return $return if $return;
 

   
}

sub tick 
{
 my $self = shift;
   my $rss = get('http://sdlperl.ath.cx/projects/SDLPerl/timeline?ticket=on&milestone=on&max=50&daysback=90&format=rss');
   return 1 unless $rss;
   my $xml = XMLin($rss);
   my $spl = $xml->{channel}->{item}->[0]->{guid}->{content};

   unless ($spl eq $old_count || $quite)
   {
   my $send = "[Trac Update]";
      $self->say(channel => '#sdl', body=>"$send");
      $send = 'Date: '. $xml->{channel}->{item}->[0]->{pubDate};
      $self->say(channel => '#sdl', body=>"$send");
      $send = 'Title: '. $xml->{channel}->{item}->[0]->{title};
      $self->say(channel => '#sdl', body=>"$send");
      $send = 'Link: '. $xml->{channel}->{item}->[0]->{link};
      $self->say(channel => '#sdl', body=>"$send");

      $old_count = $xml->{channel}->{item}->[0]->{guid}->{content};
     }
   return 1;
}



SDLBot->new(
	server => 'irc.perl.org',
	channels => [ '#sdl' ],
	nick => 'SDLbot',
)->run();


sub ticket
{
  my $message = shift;
  if ( $message->{body} =~ /(TT)(\d+)/) 
  {
    return "Ticket $2 is at http://sdlperl.ath.cx/projects/SDLPerl/ticket/$2";
  }
 

}



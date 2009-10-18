package SDL::Game::Rect;
use strict;
use warnings;
use SDL::Rect;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $x = shift || 0;
    my $y = shift || 0;
    my $w = shift || 0;
    my $h = shift || 0;

    my $self = {};
    bless $self, $class;

    $self->{rect} = SDL::Rect->new(
            -x      => $x,
            -y      => $y,
            -width  => $w,
            -height => $h,
        );

    return $self;
}

############################
## duplicated accessors
############################
sub x      { return shift->{rect}->x(@_) }
sub left   { return shift->{rect}->x(@_) }
sub top    { return shift->{rect}->y(@_) }
sub y      { return shift->{rect}->y(@_) }

sub w      { return shift->{rect}->width(@_)  }
sub width  { return shift->{rect}->width(@_)  }
sub h      { return shift->{rect}->height(@_) }
sub height { return shift->{rect}->height(@_) }

###########################
## main rect accessor
###########################
sub rect {
    return shift->{rect};
}

#############################
## extra accessors
#############################
sub bottom {
    my ($self, $val) = (@_);
    if (defined $val) {
        $self->top($val - $self->height); # y = val - height
    }
    return $self->top + $self->height; # y + height
}

sub right {
    my ($self, $val) = (@_);
    if (defined $val) {
        $self->left($val - $self->width); # x = val - width
    }
    return $self->left + $self->width; # x + width
}

sub center_x {
    my ($self, $val) = (@_);
    if (defined $val) {
        $self->left($val - ($self->width >> 1)); # x = val - (width/2)
    }
    return $self->left + ($self->width >> 1); # x + (width/2)
}

sub center_y {
    my ($self, $val) = (@_);
    if (defined $val) {
        $self->top($val - ($self->height >> 1)); # y = val - (height/2)
    }
    return $self->top + ($self->height >> 1); # y + (height/2)
}

sub size {
    my ($self, $w, $h) = (@_);
    
    return ($self->width, $self->height)  # (width, height)
        unless (defined $w or defined $h);
        
    if (defined $w) {
        $self->width($w); # width
    }
    if (defined $h) {
        $self->height($h); # height
    }
}

sub top_left {
    my ($self, $y, $x) = (@_);
    
    return ($self->top, $self->left) # (top, left)
        unless (defined $y or defined $x);

    if (defined $x) {
        $self->left($x); # left
    }
    if (defined $y) {
        $self->top($y); # top
    }
    return;
}

sub mid_left {
    my ($self, $centery, $x) = (@_);
    
    return ($self->top + ($self->height >> 1), $self->left) # (centery, left)
        unless (defined $centery or defined $x);
    
    if (defined $x) {
        $self->left($x); # left
    }
    if (defined $centery) {
        $self->top($centery - ($self->height >> 1)); # y = centery - (height/2)
    }
    return;
}

sub bottom_left {
    my ($self, $bottom, $x) = (@_);
    
    return ($self->top + $self->height, $self->left) # (bottom, left)
        unless (defined $bottom or defined $x);

    if (defined $x) {
        $self->left($x); # left
    }
    if (defined $bottom) {
        $self->top($bottom - $self->height); # y = bottom - height
    }
    return;
}

sub center {
    my ($self, $centerx, $centery) = (@_);
    
    return ($self->left + ($self->width >> 1), $self->top + ($self->height >> 1))
        unless (defined $centerx or defined $centery);

    if (defined $centerx) {
        $self->left($centerx - ($self->width >> 1)); # x = centerx - (width/2)        
    }
    if (defined $centery) {
        $self->top($centery - ($self->height >> 1)); # y = centery - (height/2)
    }
    return;
}

sub top_right {
    my ($self, $y, $right) = (@_);
    
    return ($self->top, $self->left + $self->width) # (top, right)
        unless (defined $y or defined $right);

    if (defined $right) {
        $self->left($right - $self->width); # x = right - width
    }
    if (defined $y) {
        $self->top($y); # top
    }
    return;
}

sub mid_right {
    my ($self, $centery, $right) = (@_);
    
    return ($self->top + ($self->height >> 1), $self->left + $self->width) # (centery, right)
        unless (defined $centery or defined $right);
    
    if (defined $right) {
        $self->left($right - $self->width); # x = right - width
    }
    if (defined $centery) {
        $self->top($centery - ($self->height >> 1)); # y = centery - (height/2)
    }
    return;
}

sub bottom_right {
    my ($self, $bottom, $right) = (@_);
    
    return ($self->top + $self->height, $self->left + $self->width) # (bottom, right)
        unless (defined $bottom or defined $right);

    if (defined $right) {
        $self->left($right - $self->width); # x = right - width
    }
    if (defined $bottom) {
        $self->top($bottom - $self->height); # y = bottom - height
    }
    return;
}

sub mid_top {
    my ($self, $centerx, $y) = (@_);
    
    return ($self->left + ($self->width >> 1), $self->top) # (centerx, top)
        unless (defined $centerx or defined $y);
    
    if (defined $y) {
        $self->top($y); # top
    }
    if (defined $centerx) {
        $self->left($centerx - ($self->width >> 1)); # x = centerx - (width/2)
    }
    return;
}

sub mid_bottom {
    my ($self, $centerx, $bottom) = (@_);
    
    return ($self->left + ($self->width >> 1), $self->top + $self->height) # (centerx, bottom)
        unless (defined $centerx or defined $bottom);
    
    if (defined $bottom) {
        $self->top($bottom - $self->height); # y = bottom - height
    }
    if (defined $centerx) {
        $self->left($centerx - ($self->width >> 1)); # x = centerx - (width/2)
    }
    return;    
}

###############################
## methods                   ##
###############################

{
    no strict 'refs';
    *{'duplicate'} = *{copy};
}

sub copy {
    my $self = shift;
    return $self->new(
        -top    => $self->top,
        -left   => $self->left,
        -width  => $self->width,
        -height => $self->height,
    );
}

sub move {
    my ($self, $x, $y) = (@_);
    if (not defined $x or not defined $y) {
        _error( "must receive x and y positions as argument" );
    }
    $self->x($self->x + $x);
    $self->y($self->y + $y);
    
    return;
}

sub inflate {
    my ($self, $x, $y) = (@_);
    if (not defined $x or not defined $y) {
        _error( "must receive x and y positions as argument" );
    }
    
    $self->x( $self->x - ($x / 2) );
    $self->y( $self->y - ($y / 2) );
    
    $self->w( $self->w + $x );
    $self->h( $self->h + $y );
}

sub _get_clamp_coordinates {
    my ($self_pos, $self_len, $rect_pos, $rect_len) = (@_);

    if ($self_len >= $rect_len) {
        return $rect_pos + ($rect_len / 2) - ($self_len / 2);
    }
    elsif ($self_pos < $rect_pos) {
        return $rect_pos;
    }
    elsif ( ($self_pos + $self_len) > ($rect_pos + $rect_len) ) {
        return $rect_pos + $rect_len - $self_len;
    }
    else {
        return $self_pos;
    }
}

sub clamp {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect') or $rect->isa('SDL::Game::Rect')) {
        _error( "must receive an SDL::Rect-based object" );
    }

    my $x = _get_clamp_coordinates($self->x, $self->w, $rect->x, $rect->w);
    my $y = _get_clamp_coordinates($self->y, $self->h, $rect->y, $rect->h);
    
    $self->x($x);
    $self->y($y);
    
    return;
}

sub _get_intersection_coordinates {
    my ($self, $rect) = (@_);
    my ($x, $y, $w, $h);
    
INTERSECTION: 
    {
        ### Left
        if (($self->x >= $rect->x) && ($self->x < ($rect->x + $rect->w))) {
            $x = $self->x;
        }
        elsif (($rect->x >= $self->x) && ($rect->x < ($self->x + $self->w))) {
            $x = $rect->x;
        }
        else {
            last INTERSECTION;
        }

        ## Right
        if ((($self->x + $self->w) > $rect->x) && (($self->x + $self->w) <= ($rect->x + $rect->w))) {
            $w = ($self->x + $self->w) - $x;
        }
        elsif ((($rect->x + $rect->w) > $self->x) && (($rect->x + $rect->w) <= ($self->x + $self->w))) {
            $w = ($rect->x + $rect->w) - $x;
        }
        else {
            last INTERSECTION;
        }

        ## Top
        if (($self->y >= $rect->y) && ($self->y < ($rect->y + $rect->h))) {
            $y = $self->y;
        }
        elsif (($rect->y >= $self->y) && ($rect->y < ($self->y + $self->h))) {
            $y = $rect->y;
        }
        else {
            last INTERSECTION;
        }

        ## Bottom
        if ((($self->y + $self->h) > $rect->y) && (($self->y + $self->h) <= ($rect->y + $rect->h))) {
            $h = ($self->y + $self->h) - $y;
        }
        elsif ((($rect->y + $rect->h) > $self->y) && (($rect->y + $rect->h) <= ($self->y + $self->h))) {
            $h = ($rect->y + $rect->h) - $y;
        }
        else {
            last INTERSECTION;
        }

        return ($x, $y, $w, $h);
    }
    
    # if we got here, the two rects do not intersect
    return ($self->x, $self->y, 0, 0);

}


sub clip {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect') or $rect->isa('SDL::Game::Rect')) {
        _error( "must receive an SDL::Rect-based object" );
    }

    my ($x, $y, $w, $h) = _get_intersection_coordinates($self, $rect);
    
    $self->x($x);
    $self->y($y);
    $self->w($w);
    $self->h($h);
    
    return;
}


sub _test_union {
    my ($self, $rect) = (@_);
    my ($x, $y, $w, $h);

    $x = $self->x < $rect->x ? $self->x : $rect->x;  # MIN
    $y = $self->y < $rect->y ? $self->y : $rect->y;  # MIN
    
    $w = ($self->x + $self->w) > ($rect->x + $rect->w)
       ? ($self->x + $self->w) - $x
       : ($rect->x + $rect->w) - $x
       ;  # MAX
       
    $h = ($self->y + $self->h) > ($rect->y + $rect->h)
       ? ($self->y + $self->h) - $y
       : ($rect->y + $rect->h) - $y
       ;  # MAX

    return ($x, $y, $w, $h);
}


sub _test_unionall {
    my ($self, $rects) = (@_);
    
    # initial values for union rect
    my $left   = $self->x;
    my $top    = $self->y;
    my $right  = $self->x + $self->w;
    my $bottom = $self->y + $self->h;
    
    foreach my $rect (@{$rects}) {
        unless ($rect->isa('SDL::Rect') or $rect->isa('SDL::Game::Rect')) {
            # TODO: better error message, maybe saying which item 
            # is the bad one (by list position)
            _error( "must receive only SDL::Rect-based objects" );
        }

        $left   = $rect->x if $rect->x < $left; # MIN
        $top    = $rect->y if $rect->y < $top; # MIN
        $right  = ($rect->x + $rect->w) if ($rect->x + $rect->w) > $right;  # MAX
        $bottom = ($rect->y + $rect->h) if ($rect->y + $rect->h) > $bottom; # MAX 
    }
    
    return ($left, $top, $right - $left, $bottom - $top);
}


sub union {
    my ($self, @rects) = (@_);
    
    unless (@rects > 0) {
        _error( "must receive at least one SDL::Rect-based objects as an argument" );
    }

    my ($x, $y, $w, $h) = _test_unionall($self, \@rects);
    
    $self->x($x);
    $self->y($y);
    $self->w($w);
    $self->h($h);
    
    return;
}

sub _check_fit {
    my ($self, $rect) = (@_);
    
    my $x_ratio = $self->w / $rect->w;
    my $y_ratio = $self->h / $rect->h;
    my $max_ratio = ($x_ratio > $y_ratio) ? $x_ratio : $y_ratio;

    my $w = int ($self->w / $max_ratio);
    my $h = int ($self->h / $max_ratio);

    my $x = $rect->x + int (($rect->w - $w) / 2);
    my $y = $rect->y + int (($rect->h - $h) / 2);
    
    return ($x, $y, $w, $h);
}


sub fit {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect') or $rect->isa('SDL::Game::Rect')) {
        _error( "must receive an SDL::Rect-based object" );
    }

    my ($x, $y, $w, $h) = _check_fit($self, $rect);
    
    $self->x($x);
    $self->y($y);
    $self->w($w);
    $self->h($h);
    
    return;
}

sub normalize {
    my $self = shift;
    
    if ($self->w < 0) {
        $self->x($self->x + $self->w);
        $self->w(-$self->w);
    }
    
    if ($self->h < 0) {
        $self->y( $self->y + $self->h);
        $self->h(-$self->h);
    }
    return;
}

sub contains {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        _error( "must receive an SDL::Rect-based object" );
    }
    
    my $contained = ($self->x <= $rect->x) 
                 && ($self->y <= $rect->y) 
                 && ($self->x + $self->w >= $rect->x + $rect->w) 
                 && ($self->y + $self->h >= $rect->y + $rect->h) 
                 && ($self->x + $self->w > $rect->x) 
                 && ($self->y + $self->h > $rect->y)
                 ;
                 
    return $contained;
}

sub collide_point {
    my ($self, $x, $y) = (@_);

    unless (defined $x and defined $y) {
        _error( "must receive (x,y) as arguments" );
    }
    
    my $inside = $x >= $self->x 
              && $x < $self->x + $self->w 
              && $y >= $self->y 
              && $y < $self->y + $self->h
              ;

    return $inside;
}

sub _do_rects_intersect {
    my ($rect_A, $rect_B) = (@_);
    
    return (
               ($rect_A->x >= $rect_B->x && $rect_A->x < $rect_B->x + $rect_B->w)  
            || ($rect_B->x >= $rect_A->x && $rect_B->x < $rect_A->x + $rect_A->w)
           ) 
           &&
           (
               ($rect_A->y >= $rect_B->y && $rect_A->y < $rect_B->y + $rect_B->h)
            || ($rect_B->y >= $rect_A->y && $rect_B->y < $rect_A->y + $rect_A->h)
           )
           ;
}


sub collide_rect {
    my ($self, $rect) = (@_);

    unless ($rect->isa('SDL::Rect') or $rect->isa('SDL::Game::Rect')) {
        _error( "must receive an SDL::Rect-based object" );
    }
    
    return _do_rects_intersect($self, $rect);
}

sub collide_list {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'ARRAY') {
        _error( "must receive an array reference of SDL::Rect-based objects" );
    }

    for(my $i = 0; $i < @{$rects}; $i++) {
        if ( _do_rects_intersect($self, $rects->[$i]) ) {
            return $i;
        }
    }
    return;
}

sub collide_list_all {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'ARRAY') {
        _error( "must receive an array reference of SDL::Rect-based objects" );
    }

    my @collisions = ();
    for(my $i = 0; $i < @{$rects}; $i++) {
        if ( _do_rects_intersect($self, $rects->[$i]) ) {
            push @collisions, $i;
        }
    }
    return \@collisions;
}

sub collide_hash {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'HASH') {
        _error( "must receive an hash reference of SDL::Rect-based objects" );
    }
    
    while ( my ($key, $value) = each %{$rects} ) {
        unless ($value->isa('SDL::Rect') or $value->isa('SDL::Game::Rect')) {
            _error( "hash element of key '$key' is not an SDL::Rect-based object" );
        }
        
        if ( _do_rects_intersect($self, $value) ) {
            return ($key, $value);
        }
    }
    return (undef, undef);
}

sub collide_hash_all {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'HASH') {
        _error( "must receive an hash reference of SDL::Rect-based objects" );
    }
    
    my %collisions = ();
    while ( my ($key, $value) = each %{$rects} ) {
        unless ($value->isa('SDL::Rect')) {
            _error( "hash element of key '$key' is not an SDL::Rect-based object" );
        }
        
        if ( _do_rects_intersect($self, $value) ) {
            $collisions{$key} = $value;
        }
    }
    return \%collisions;
}

sub _error {
    require Carp;
    Carp::croak @_;
}


"all your base are belong to us";
__END__

=head1 NAME

SDL::Game::Rect - SDL::Game object for storing and manipulating rectangular coordinates

=head1 SYNOPSIS

   my $rect = SDL::Game::Rect->new( 10, 20, 5, 5 );  # top, left, width, height

   my $another_rect = SDL::Game::Rect->new( 10, 30, 5, 8);

   if ( $rect->collide_rect ($another_rect) ) {
       print "collision!!!\n";

       $rect->move($new_x, $new_y);
   }

=head1 WARNING

B<< This module is ***EXPERIMENTAL*** >>

It is being designed for the new SDL Perl API, so B<< things may change at any given time >>. In particular, pay attention to the caveat below: that'll definitely go away in the future and will require changes on your account.

=head2 USAGE CAVEAT

SDL Perl uses some intricate XS magic that doesn't allow us to just I<< use base 'SDL::Rect' >>. So, even though we provide the very same accessors (and more! see below), B<< other SDL modules that take a SDL::Rect object as argument won't accept passing an SDL::Game::Rect >> (yet). To work around this we provide the C<< rect() >> method, which returns a vanilla C<< SDL::Rect >> object with the appropriate dimensions. So, for example, if C<< $gamerect >> is a C<< SDL::Game::Rect >> object, then instead of doing something like this will trigger a fatal error:

   $app->update( $gamerect );  # this will fail!

instead, you should do this (for now):

    $app->update( $gamerect->rect ); # ok!

The SDL Perl development team is working to fix this. If you want to help, please join us in the mailing list or in #sdl on I<< irc.perl.org >>.


=head1 DESCRIPTION

C<< SDL::Game::Rect >> object are used to store and manipulate rectangular areas. Rect objects are created from a combination of left (or x), top (or y), width (or w) and height (or h) values, just like raw C<< SDL::Rect objects >>.

All C<< SDL::Game::Rect >> methods that change either position or size of a Rect are "in-place". This means they change the Rect whose method was called and return nothing.


=head2 ATTRIBUTES

All Rect attributes are acessors, meaning you can get them by name, and set them by passing a value:

   $rect->left(15);
   $rect->left;       # 15

The Rect object has several attributes which can be used to resize, move and align the Rect.


=over 4

=item * width, w - gets/sets object's width

=item * height, h - gets/sets object's height

=item * left, x - moves the object left position to match the given coordinate

=item * top, y  - moves the object top position to match the given coordinate

=item * bottom - moves the object bottom position to match the given coordinate

=item * right - moves the object right position to match the given coordinate

=item * center_x - moves the object's horizontal center to match the given coordinate

=item * center_y - moves the object's vertical center to match the given coordinate

=back

Some of the attributes above can be fetched or set in pairs:

  $rect->top_left(10, 15);   # top is now 10, left is now 15

  my ($width, $height) = $rect->size;


=over 4

=item * size - gets/sets object's size (width, height)

=item * top_left - gets/sets object's top and left positions

=item * mid_left - gets/sets object's vertical center and left positions

=item * bottom_left - gets/sets object's bottom and left positions

=item * center - gets/sets object's center (horizontal(x), vertical(y))

=item * top_right - gets/sets object's top and right positions

=item * mid_right - gets/sets object's vertical center and right positions

=item * bottom_right - gets/sets object's bottom and right positions

=item * mid_top - gets/sets object's horizontal center and top positions

=item * mid_bottom - gets/sets object's horizontal center and bottom positions

=back


=head2 METHODS 

Methods denoted as receiving Rect objects can receive either C<<SDL::Game::Rect>> or raw C<<SDL::Rect>> objects.

=head3 new ($left, $top, $width, $height)

Returns a new Rect object with the given coordinates. If any value is omitted (by passing undef), 0 is used instead.

=head3 copy

=head3 duplicate

Returns a new Rect object having the same position and size as the original

=head3 move(x, y)

Moves current Rect by the given offset. The x and y arguments can be any integer value, positive or negative.

=head3 inflate(x, y)

Grows or shrinks the rectangle. Rect's size is changed by the given offset. The rectangle remains centered around its current center. Negative values make ita shrinked rectangle instead.

=head3 clamp($rect)

Moves original Rect to be completely inside the Rect object passed as an argument. If the current Rect is too large to fit inside the passed Rect, it is centered inside it, but its size is not changed.

=head3 clip($rect)

Turns the original Rect into the intersection between it and the Rect object passed as an argument. That is, the original Rect gets cropped to be completely inside the Rect object passed as an argument. If the two rectangles do not overlap to begin with, the Rect bcomes zero-sized, retaining its the original (x,y) coordinates.

=head3 union($rect)

=head3 union( $rect1, $rect2, ... )

Makes the original Rect big enough to completely cover the area of itself and all other Rects passed as an argument. As the Rects can have any given dimensions and positions, there may be area inside the new Rect that is not covered by the originals.

=head3 fit($rect)

Moves and resizes the original Rect to fit the Rect object passed as an argument. The aspect ratio of the original Rect is preserved, so it may be smaller than the target in either width or height. 

=head3 normalize

Corrects negative sizes, flipping width/height of the Rect if they have a negative size. No repositioning is made so the rectangle will remain in the same place, but the negative sides will be swapped.

=head3 contains($rect)

Returns true (non-zero) when the argument is completely inside the Rect. Otherwise returns undef.

=head3 collide_point(x, y)

Returns true (non-zero) if the given point is inside the Rect, otherwise returns undef. A point along the right or bottom edge is not considered to be inside the rectangle.

=head3 collide_rect($rect)

Returns true (non-zero) if any portion of either rectangles overlap (except for the top+bottom or left+right edges).

=head3 collide_list( [$rect1, $rect2, ...] )

Test whether the rectangle collides with any in a sequence of rectangles, passed as an ARRAY REF. The index of the first collision found is returned. Returns undef if no collisions are found.

=head3 collide_list_all( [$rect1, $rect2, ...] )

Returns an ARRAY REF of all the indices that contain rectangles that collide with the Rect. If no intersecting rectangles are found, an empty list ref is returned. 

=head3 collide_hash( {key1 => $rect1, key2 => $rect2, ...} )

Receives a HASH REF and returns the a (key, value) list with the key and value of the first hash item that collides with the Rect. If no collisions are found, returns (undef, undef).

=head3 collide_hash_all( {key1 => $rect1, key2 => $rect2, ...} )

Returns a HASH REF of all the key and value pairs that intersect with the Rect. If no collisions are found an empty hash ref is returned. 


=head1 AUTHOR

Breno G. de Oliveira, C<< <garu at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to the bug tracker. I will be notified, and then you'll automatically be notified of progress on your bug as we make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SDL::Game::Rect


=head1 ACKNOWLEDGEMENTS

Many thanks to all SDL_Perl contributors, and to the authors of pygame.rect, in which this particular module is heavily based.

=head1 COPYRIGHT & LICENSE

Copyright 2009 The SDL Perl Development Team, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=head1 SEE ALSO

perl, L<< SDL >>, L<< SDL::Rect >>

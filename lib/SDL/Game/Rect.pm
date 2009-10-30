package SDL::Game::Rect;
use strict;
use warnings;
use Carp;
use base 'SDL::Rect';

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $x = shift || 0;
    my $y = shift || 0;
    my $w = shift || 0;
    my $h = shift || 0;

    my $self = $class->SUPER::new($x, $y, $w, $h);
    unless ($$self) {
        #require Carp;
        croak SDL::get_error();
    }
    bless $self, $class;
    return $self;
}

#############################
## extra accessors
#############################

sub left {
    my $self = shift;
    $self->x(@_);
}

sub top {
    my $self = shift;
    $self->y(@_);
}

sub width {
    my $self = shift;
    $self->w(@_);
}

sub height {
    my $self = shift;
    $self->h(@_);
}

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

sub centerx {
    my ($self, $val) = (@_);
    if (defined $val) {
        $self->left($val - ($self->width >> 1)); # x = val - (width/2)
    }
    return $self->left + ($self->width >> 1); # x + (width/2)
}

sub centery {
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

sub topleft {
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

sub midleft {
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

sub bottomleft {
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

sub topright {
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

sub midright {
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

sub bottomright {
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

sub midtop {
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

sub midbottom {
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
        #require Carp;
        croak "must receive x and y positions as argument";
    }
    return $self->new(
        -top    => $self->top + $y,
        -left   => $self->left + $x,
        -width  => $self->width,
        -height => $self->height,
    );
}

sub move_ip {
    my ($self, $x, $y) = (@_);
    if (not defined $x or not defined $y) {
        #require Carp;
        croak "must receive x and y positions as argument";
    }
    $self->x($self->x + $x);
    $self->y($self->y + $y);
    
    return;
}

sub inflate {
    my ($self, $x, $y) = (@_);
    if (not defined $x or not defined $y) {
        #require Carp;
        croak "must receive x and y positions as argument";
    }
    
    return $self->new(
        -left   => $self->left   - ($x / 2),
        -top    => $self->top    - ($y / 2),
        -width  => $self->width  + $x,
        -height => $self->height + $y,
    );
}

sub inflate_ip {
    my ($self, $x, $y) = (@_);
    if (not defined $x or not defined $y) {
        #require Carp;
        croak "must receive x and y positions as argument";
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
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }

    my $x = _get_clamp_coordinates($self->x, $self->w, $rect->x, $rect->w);
    my $y = _get_clamp_coordinates($self->y, $self->h, $rect->y, $rect->h);
    
    return $self->new($x, $y, $self->w, $self->h);
}

sub clamp_ip {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
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
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }

    my ($x, $y, $w, $h) = _get_intersection_coordinates($self, $rect);
    
    return $self->new($x, $y, $w, $h);
}

sub clip_ip {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
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

sub union {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }
    
    my ($x, $y, $w, $h) = _test_union($self, $rect);
    return $self->new($x, $y, $w, $h);
}

sub union_ip {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }
    
    my ($x, $y, $w, $h) = _test_union($self, $rect);
    
    $self->x($x);
    $self->y($y);
    $self->w($w);
    $self->y($h);
    
    return;
}

sub _test_unionall {
    my ($self, $rects) = (@_);
    
    # initial values for union rect
    my $left   = $self->x;
    my $top    = $self->y;
    my $right  = $self->x + $self->w;
    my $bottom = $self->y + $self->h;
    
    foreach my $rect (@{$rects}) {
        unless ($rect->isa('SDL::Rect')) {
            # TODO: better error message, maybe saying which item 
            # is the bad one (by list position)
            croak "must receive an array reference of SDL::Rect-based objects";
        }

        $left   = $rect->x if $rect->x < $left; # MIN
        $top    = $rect->y if $rect->y < $top; # MIN
        $right  = ($rect->x + $rect->w) if ($rect->x + $rect->w) > $right;  # MAX
        $bottom = ($rect->y + $rect->h) if ($rect->y + $rect->h) > $bottom; # MAX 
    }
    
    return ($left, $top, $right - $left, $bottom - $top);
}

sub unionall {
    my ($self, $rects) = (@_);
    
    unless (defined $rects and ref $rects eq 'ARRAY') {
        croak "must receive an array reference of SDL::Rect-based objects";
    }

    my ($x, $y, $w, $h) = _test_unionall($self, $rects);
    
    return $self->new($x, $y, $w, $h);
}

sub unionall_ip {
    my ($self, $rects) = (@_);
    
    unless (defined $rects and ref $rects eq 'ARRAY') {
        croak "must receive an array reference of SDL::Rect-based objects";
    }

    my ($x, $y, $w, $h) = _test_unionall($self, $rects);
    
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
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }

    my ($x, $y, $w, $h) = _check_fit($self, $rect);
    
    return $self->new ($x, $y, $w, $h);
}

sub fit_ip {
    my ($self, $rect) = (@_);
    
    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
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
        croak "must receive an SDL::Rect-based object";
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

sub collidepoint {
    my ($self, $x, $y) = (@_);

    unless (defined $x and defined $y) {
        croak "must receive (x,y) as arguments";
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


sub colliderect {
    my ($self, $rect) = (@_);

    unless ($rect->isa('SDL::Rect')) {
        croak "must receive an SDL::Rect-based object";
    }
    
    return _do_rects_intersect($self, $rect);
}

sub collidelist {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'ARRAY') {
        croak "must receive an array reference of SDL::Rect-based objects";
    }

    for(my $i = 0; $i < @{$rects}; $i++) {
        if ( _do_rects_intersect($self, $rects->[$i]) ) {
            return $i;
        }
    }
    return;
}

sub collidelistall {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'ARRAY') {
        croak "must receive an array reference of SDL::Rect-based objects";
    }

    my @collisions = ();
    for(my $i = 0; $i < @{$rects}; $i++) {
        if ( _do_rects_intersect($self, $rects->[$i]) ) {
            push @collisions, $i;
        }
    }
    return \@collisions;
}

sub collidehash {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'HASH') {
        croak "must receive an hash reference of SDL::Rect-based objects";
    }
    
    while ( my ($key, $value) = each %{$rects} ) {
        unless ($value->isa('SDL::Rect')) {
            croak "hash element of key '$key' is not an SDL::Rect-based object";
        }
        
        if ( _do_rects_intersect($self, $value) ) {
            return ($key, $value);
        }
    }
    return (undef, undef);
}

sub collidehashall {
    my ($self, $rects) = (@_);

    unless (defined $rects and ref $rects eq 'HASH') {
        croak "must receive an hash reference of SDL::Rect-based objects";
    }
    
    my %collisions = ();
    while ( my ($key, $value) = each %{$rects} ) {
        unless ($value->isa('SDL::Rect')) {
            croak "hash element of key '$key' is not an SDL::Rect-based object";
        }
        
        if ( _do_rects_intersect($self, $value) ) {
            $collisions{$key} = $value;
        }
    }
    return \%collisions;
}


42;
__END__

=head1 NAME

SDL::Game::Rect - SDL::Game object for storing and manipulating rectangular coordinates

=head1 SYNOPSIS


=head1 DESCRIPTION

C<< SDL::Game::Rect >> object are used to store and manipulate rectangular areas. Rect objects are created from a combination of left (or x), top (or y), width (or w) and height (or h) values, just like raw C<< SDL::Rect objects >>.

All C<< SDL::Game::Rect >> methods that change either position or size of a Rect return B<a new copy> of the Rect with the affected changes. The original Rect is B<not> modified. If you wish to modify the current Rect object, you can use the equivalent "in-place" methods that do not return but instead affects the original Rect. These "in-place" methods are denoted with the "ip" suffix. Note that changing a Rect's attribute is I<always> an in-place operation.


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

=item * centerx - moves the object's horizontal center to match the given coordinate

=item * centery - moves the object's vertical center to match the given coordinate

=back

Some of the attributes above can be fetched or set in pairs:

  $rect->topleft(10, 15);   # top is now 10, left is now 15

  my ($width, $height) = $rect->size;


=over 4

=item * size - gets/sets object's size (width, height)

=item * topleft - gets/sets object's top and left positions

=item * midleft - gets/sets object's vertical center and left positions

=item * bottomleft - gets/sets object's bottom and left positions

=item * center - gets/sets object's center (horizontal(x), vertical(y))

=item * topright - gets/sets object's top and right positions

=item * midright - gets/sets object's vertical center and right positions

=item * bottomright - gets/sets object's bottom and right positions

=item * midtop - gets/sets object's horizontal center and top positions

=item * midbottom - gets/sets object's horizontal center and bottom positions

=back


=head2 METHODS 

Methods denoted as receiving Rect objects can receive either C<<SDL::Game::Rect>> or raw C<<SDL::Rect>> objects.

=head3 new ($left, $top, $width, $height)

Returns a new Rect object with the given coordinates. If any value is omitted (by passing undef), 0 is used instead.

=head3 copy

=head3 duplicate

Returns a new Rect object having the same position and size as the original

=head3 move(x, y)

Returns a new Rect that is moved by the given offset. The x and y arguments can be any integer value, positive or negative.

=head3 move_ip(x, y)

Same as C<<move>> above, but moves the current Rect in place and returns nothing.

=head3 inflate(x, y)

Grows or shrinks the rectangle. Returns a new Rect with the size changed by the given offset. The rectangle remains centered around its current center. Negative values will return a shrinked rectangle instead.

=head3 inflate_ip(x, y)

Same as C<<inflate>> above, but grows/shrinks the current Rect in place and returns nothing.

=head3 clamp($rect)

Returns a new Rect moved to be completely inside the Rect object passed as an argument. If the current Rect is too large to fit inside the passed Rect, it is centered inside it, but its size is not changed.

=head3 clamp_ip($rect)

Same as C<<clamp>> above, but moves the current Rect in place and returns nothing.

=head3 clip($rect)

Returns a new Rect with the intersection between the two Rect objects, that is, returns a new Rect cropped to be completely inside the Rect object passed as an argument. If the two rectangles do not overlap to begin with, a Rect with 0 size is returned, in the original Rect's (x,y) coordinates.

=head3 clip_ip($rect)

Same as C<<clip>> above, but crops the current Rect in place and returns nothing. As the original method, the Rect becomes zero-sized if the two rectangles do not overlap to begin with, retaining its (x, y) coordinates.

=head3 union($rect)

Returns a new rectangle that completely covers the area of the current Rect and the one passed as an argument. There may be area inside the new Rect that is not covered by the originals.

=head3 union_ip($rect)

Same as C<<union>> above, but resizes the current Rect in place and returns nothing.

=head3 unionall( [$rect1, $rect2, ...] )

Returns the union of one rectangle with a sequence of many rectangles, passed as an ARRAY REF.

=head3 unionall_ip( [$rect1, $rect2, ...] )

Same as C<<unionall>> above, but resizes the current Rect in place and returns nothing.

=head3 fit($rect)

Returns a new Rect moved and resized to fit the Rect object passed as an argument. The aspect ratio of the original Rect is preserved, so the new rectangle may be smaller than the target in either width or height. 

=head3 fit_ip($rect)

Same as C<<fit>> above, but moves/resizes the current Rect in place and returns nothing.

=head3 normalize

Corrects negative sizes, flipping width/height of the Rect if they have a negative size. No repositioning is made so the rectangle will remain in the same place, but the negative sides will be swapped. This method returns nothing.

=head3 contains($rect)

Returns true (non-zero) when the argument is completely inside the Rect. Otherwise returns undef.

=head3 collidepoint(x, y)

Returns true (non-zero) if the given point is inside the Rect, otherwise returns undef. A point along the right or bottom edge is not considered to be inside the rectangle.

=head3 colliderect($rect)

Returns true (non-zero) if any portion of either rectangles overlap (except for the top+bottom or left+right edges).

=head3 collidelist( [$rect1, $rect2, ...] )

Test whether the rectangle collides with any in a sequence of rectangles, passed as an ARRAY REF. The index of the first collision found is returned. Returns undef if no collisions are found.

=head3 collidelistall( [$rect1, $rect2, ...] )

Returns an ARRAY REF of all the indices that contain rectangles that collide with the Rect. If no intersecting rectangles are found, an empty list ref is returned. 

=head3 collidehash( {key1 => $rect1, key2 => $rect2, ...} )

Receives a HASH REF and returns the a (key, value) list with the key and value of the first hash item that collides with the Rect. If no collisions are found, returns (undef, undef).

=head3 collidehashall( {key1 => $rect1, key2 => $rect2, ...} )

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

Copyright 2009 Breno G. de Oliveira, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=head1 SEE ALSO

perl, L<SDL>, L<SDL::Rect>, L<SDL::Game>

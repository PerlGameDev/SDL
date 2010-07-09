package SDLx::Rect;
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


1; #NOT 42!


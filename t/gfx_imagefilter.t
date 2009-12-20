#!perl
use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Config;
use SDL::Video;
use SDL::Surface;
use SDL::GFX::ImageFilter;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_gfx_imagefilter') )
{
    plan( skip_all => 'SDL_gfx_imagefilter support not compiled' );
}
else
{
    plan( tests => 7 );
}

my @done =qw/
MMX_detect
/;

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
my $pixel   = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect( $display, SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );

if(!$display)
{
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

my $mmx_before = SDL::GFX::ImageFilter::MMX_detect();
is($mmx_before == 1 || $mmx_before == 0, 1,           "MMX_detect == $mmx_before");
is(SDL::GFX::ImageFilter::MMX_off(),     undef,       'MMX_off');
is(SDL::GFX::ImageFilter::MMX_detect(),  0,           "MMX_detect (MMX is off now)");
is(SDL::GFX::ImageFilter::MMX_on(),      undef,       'MMX_on');
is(SDL::GFX::ImageFilter::MMX_detect(),  $mmx_before, "MMX_detect (MMX is same as at start)");

#add(Src1, Src2, Dest, length)
#mean(Src1, Src2, Dest, length)
#sub(Src1, Src2, Dest, length)
#abs_diff(Src1, Src2, Dest, length)
#mult(Src1, Src2, Dest, length)
#mult_nor(Src1, Src2, Dest, length)
#mult_div_by_2(Src1, Src2, Dest, length)
#mult_div_by_4(Src1, Src2, Dest, length)
#bit_and(Src1, Src2, Dest, length)
#bit_or(Src1, Src2, Dest, length)
#div(Src1, Src2, Dest, length)
#bit_negation(Src1, Dest, length)
#add_byte(Src1, Dest, length, C)
#add_uint(Src1, Dest, length, C)
#add_byte_to_half(Src1, Dest, length, C)
#sub_byte(Src1, Dest, length, C)
#sub_uint(Src1, Dest, length, C)
#shift_right(Src1, Dest, length, N)
#shift_right_uint(Src1, Dest, length, N)
#mult_by_byte(Src1, Dest, length, C)
#shift_right_and_mult_by_byte(Src1, Dest, length, N, C)
#shift_left_byte(Src1, Dest, length, N)
#shift_left_uint(Src1, Dest, length, N)
#shift_left(Src1, Dest, length, N)
#binarize_using_threshold(Src1, Dest, length, T)
#clip_to_range(Src1, Dest, length, Tmin, Tmax)
#normalize_linear(Src1, Dest, length, Cmin, Cmax, Nmin, Nmax)
#convolve_kernel_3x3_divide(Src, Dest, rows, columns, Kernel, Divisor)
#convolve_kernel_5x5_divide(Src, Dest, rows, columns, Kernel, Divisor)
#convolve_kernel_7x7_divide(Src, Dest, rows, columns, Kernel, Divisor)
#convolve_kernel_9x9_divide(Src, Dest, rows, columns, Kernel, Divisor)
#convolve_kernel_3x3_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
#convolve_kernel_5x5_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
#convolve_kernel_7x7_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
#convolve_kernel_9x9_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
#sobel_x(Src, Dest, rows, columns)
#sobel_x_shift_right(Src, Dest, rows, columns, NRightShift)
#align_stack()
#restore_stack()


SDL::Video::update_rect($display, 0, 0, 640, 480); 

#SDL::delay(1000);

my @left = qw/
MMX_detect
MMX_off
MMX_on
add
mean
sub
abs_diff
mult
mult_nor
mult_div_by_2
mult_div_by_4
bit_and
bit_or
div
bit_negation
add_byte
add_uint
add_byte_to_half
sub_byte
sub_uint
shift_right
shift_right_uint
mult_by_byte
shift_right_and_mult_by_byte
shift_left_byte
shift_left_uint
shift_left
binarize_using_threshold
clip_to_range
normalize_linear
convolve_kernel_3x3_divide
convolve_kernel_5x5_divide
convolve_kernel_7x7_divide
convolve_kernel_9x9_divide
convolve_kernel_3x3_shift_right
convolve_kernel_5x5_shift_right
convolve_kernel_7x7_shift_right
convolve_kernel_9x9_shift_right
sobel_x
sobel_x_shift_right
align_stack
restore_stack
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done +1 ) / ($#done + $#left + 2  ) ) .'% implementation. '.($#done +1 ).'/'.($#done+$#left + 2 ); 
TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 

pass 'Are we still alive? Checking for segfaults';

done_testing;

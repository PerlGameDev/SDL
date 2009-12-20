#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_GFX_IMAGEFILTER
#include <SDL_imageFilter.h>
#endif 

MODULE = SDL::GFX::ImageFilter 	PACKAGE = SDL::GFX::ImageFilter    PREFIX = gfx_image_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http://www.ferzkopp.net/joomla/content/view/19/14/>

=cut

#ifdef HAVE_SDL_GFX_IMAGEFILTER

int
gfx_image_MMX_detect()
	CODE:
		RETVAL = SDL_imageFilterMMXdetect();
	OUTPUT:
		RETVAL

void
gfx_image_MMX_off()
	CODE:
		SDL_imageFilterMMXoff();

void
gfx_image_MMX_on()
	CODE:
		SDL_imageFilterMMXon();

int
gfx_image_add(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterAdd(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_mean(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterMean(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_sub(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterSub(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_abs_diff(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterAbsDiff(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_mult(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterMult(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_mult_nor(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterMultNor(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_mult_div_by_2(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterMultDivby2(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_mult_div_by_4(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterMultDivby4(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_bit_and(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterBitAnd(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_bit_or(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterBitOr(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_div(Src1, Src2, Dest, length)
	unsigned char *Src1
	unsigned char *Src2
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterDiv(Src1, Src2, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_bit_negation(Src1, Dest, length)
	unsigned char *Src1
	unsigned char *Dest
	int length
	CODE:
		RETVAL = SDL_imageFilterBitNegation(Src1, Dest, length);
	OUTPUT:
		RETVAL

int
gfx_image_add_byte(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char C
	CODE:
		RETVAL = SDL_imageFilterAddByte(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_add_uint(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned int C
	CODE:
		RETVAL = SDL_imageFilterAddUint(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_add_byte_to_half(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char C
	CODE:
		RETVAL = SDL_imageFilterAddByteToHalf(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_sub_byte(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char C
	CODE:
		RETVAL = SDL_imageFilterSubByte(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_sub_uint(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned int C
	CODE:
		RETVAL = SDL_imageFilterSubUint(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_shift_right(Src1, Dest, length, N)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	CODE:
		RETVAL = SDL_imageFilterShiftRight(Src1, Dest, length, N);
	OUTPUT:
		RETVAL

int
gfx_image_shift_right_uint(Src1, Dest, length, N)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	CODE:
		RETVAL = SDL_imageFilterShiftRightUint(Src1, Dest, length, N);
	OUTPUT:
		RETVAL

int
gfx_image_mult_by_byte(Src1, Dest, length, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char C
	CODE:
		RETVAL = SDL_imageFilterMultByByte(Src1, Dest, length, C);
	OUTPUT:
		RETVAL

int
gfx_image_shift_right_and_mult_by_byte(Src1, Dest, length, N, C)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	unsigned char C
	CODE:
		RETVAL = SDL_imageFilterShiftRightAndMultByByte(Src1, Dest, length, N, C);
	OUTPUT:
		RETVAL

int
gfx_image_shift_left_byte(Src1, Dest, length, N)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	CODE:
		RETVAL = SDL_imageFilterShiftLeftByte(Src1, Dest, length, N);
	OUTPUT:
		RETVAL

int
gfx_image_shift_left_uint(Src1, Dest, length, N)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	CODE:
		RETVAL = SDL_imageFilterShiftLeftUint(Src1, Dest, length, N);
	OUTPUT:
		RETVAL

int
gfx_image_shift_left(Src1, Dest, length, N)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char N
	CODE:
		RETVAL = SDL_imageFilterShiftLeft(Src1, Dest, length, N);
	OUTPUT:
		RETVAL

int
gfx_image_binarize_using_threshold(Src1, Dest, length, T)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char T
	CODE:
		RETVAL = SDL_imageFilterBinarizeUsingThreshold(Src1, Dest, length, T);
	OUTPUT:
		RETVAL

int
gfx_image_clip_to_range(Src1, Dest, length, Tmin, Tmax)
	unsigned char *Src1
	unsigned char *Dest
	int length
	unsigned char Tmin
	unsigned char Tmax
	CODE:
		RETVAL = SDL_imageFilterClipToRange(Src1, Dest, length, Tmin, Tmax);
	OUTPUT:
		RETVAL

int
gfx_image_normalize_linear(Src1, Dest, length, Cmin, Cmax, Nmin, Nmax)
	unsigned char *Src1
	unsigned char *Dest
	int length
	int Cmin
	int Cmax
	int Nmin
	int Nmax
	CODE:
		RETVAL = SDL_imageFilterNormalizeLinear(Src1, Dest, length, Cmin, Cmax, Nmin, Nmax);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_3x3_divide(Src, Dest, rows, columns, Kernel, Divisor)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char Divisor
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel3x3Divide(Src, Dest, rows, columns, Kernel, Divisor);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_5x5_divide(Src, Dest, rows, columns, Kernel, Divisor)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char Divisor
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel5x5Divide(Src, Dest, rows, columns, Kernel, Divisor);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_7x7_divide(Src, Dest, rows, columns, Kernel, Divisor)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char Divisor
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel7x7Divide(Src, Dest, rows, columns, Kernel, Divisor);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_9x9_divide(Src, Dest, rows, columns, Kernel, Divisor)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char Divisor
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel9x9Divide(Src, Dest, rows, columns, Kernel, Divisor);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_3x3_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char NRightShift
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel3x3ShiftRight(Src, Dest, rows, columns, Kernel, NRightShift);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_5x5_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char NRightShift
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel5x5ShiftRight(Src, Dest, rows, columns, Kernel, NRightShift);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_7x7_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char NRightShift
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel7x7ShiftRight(Src, Dest, rows, columns, Kernel, NRightShift);
	OUTPUT:
		RETVAL

int
gfx_image_convolve_kernel_9x9_shift_right(Src, Dest, rows, columns, Kernel, NRightShift)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	Sint16 *Kernel
	unsigned char NRightShift
	CODE:
		RETVAL = SDL_imageFilterConvolveKernel9x9ShiftRight(Src, Dest, rows, columns, Kernel, NRightShift);
	OUTPUT:
		RETVAL

int
gfx_image_sobel_x(Src, Dest, rows, columns)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	CODE:
		RETVAL = SDL_imageFilterSobelX(Src, Dest, rows, columns);
	OUTPUT:
		RETVAL

int
gfx_image_sobel_x_shift_right(Src, Dest, rows, columns, NRightShift)
	unsigned char *Src
	unsigned char *Dest
	int rows
	int columns
	unsigned char NRightShift
	CODE:
		RETVAL = SDL_imageFilterSobelXShiftRight(Src, Dest, rows, columns, NRightShift);
	OUTPUT:
		RETVAL

void
gfx_image_align_stack()
	CODE:
		SDL_imageFilterAlignStack();

void
gfx_image_restore_stack()
	CODE:
		SDL_imageFilterRestoreStack();
	
#endif

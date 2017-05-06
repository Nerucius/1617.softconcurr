#include "common.h"
#include "kernel_core.c"

/**
 * PER PIXEL KERNEL: THIS KERNEL WORKS WITH A GLOBAL WORK SIZE
 * OF IMAGE_WIDTH x IMAGE_HEIGHT AND USES ONE THREAD PER PIXEL.
 */


/**
 * Kernel Main Function
 *
 * @param img imatge amb una vora de 15 pixels per la dreta i per sot
 * @param pat patro de 16 x 16 pixels
 * @param rows files de img (incloent la vora de 15 pixel
 * @param cols columnes de img (incloent la vora de 15 pixels)
 * @param out image resultant sense cap vora
 */
__kernel void pattern_matching(
		__global unsigned char *img,
		__global unsigned char *pat,
		int rows,
		int cols,
		__global float *out) {
	int i, j;
	char val;

	i = get_global_id(1);
	j = get_global_id(0);

	int out_rows = rows - PADDING;
	int out_cols = cols - PADDING;

	// Match the pattern
	val = match_patt(img, pat, cols, i, j);
	// Write value to out image
	SET(out, out_cols, i, j, val);
}




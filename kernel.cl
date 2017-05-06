#include "common.h"

#define GET(img, cols, i, j)    (( img[i*cols + j] ))
#define SET(img, cols, i, j, v) ({ img[i*cols + j] = v; })

/**
 * PER PIXEL KERNEL: THIS KERNEL WORKS WITH A GLOBAL WORK SIZE
 * OF IMAGE_WIDTH x IMAGE_HEIGHT AND USES ONE THREAD PER PIXEL.
 */

/** Clamp a float value between upper and lower bounds */
float fclamp(float val, float upper, float lower) {
	return max(min(upper, val), lower);
}

/** Match the pattern on a single pixel coordinate */
float match_patt(
		__global unsigned char *img,
		__global unsigned char *pat,
		int cols,
		int i,
		int j) {
	int px, py;
	float sum = 0, diff;

	// Add errors for every pixel in the pattern
	for (py = 0; py < 16; py++) {
		for (px = 0; px < 16; px++) {
			unsigned char ptval = pat[py * 16 + px];
			int r = i + py;
			int c = j + px;
			diff = GET(img, cols, r, c) - ptval;
			sum += diff * diff;
		}
	}

	//sum = sum / (float)(16*16);
	sum = fclamp(sum / (16 * 16 * 16), 0, 255);
	return sum;
}


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




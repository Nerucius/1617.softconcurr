#include "common.h"
#include "kernel_core.c"

#define FACTOR 4096
#define LOC_ROWS 32
#define LOC_COLS 32
#define LOC_SIZE (LOC_ROWS * LOC_COLS)

/**
 * 32x32 IMAGE BLOCKS KERNEL: USING 32x4 THREAD PER BLOCK.
 * THIS VERSION COPIES THE PATTERN AND A FRAGMENT OF THE IMAGE
 * TO THE WORK-GROUP'S LOCAL MEMORY.
 */

/** Match the pattern on a single pixel coordinate */
float local_match_patt(
		__local unsigned char *img,
		__local unsigned char *pat,
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
	sum = fclamp(sum / FACTOR, 0, 255);
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
		const int rows,
		const int cols,
		__global float *out) {


	__local unsigned char LOC_PAT[16 * 16];
	__local unsigned char LOC_IMG[LOC_SIZE];

	// Kernel row and col
	const int row = get_global_id(1) * 8;
	const int col = get_global_id(0);
	const int out_rows = rows - PADDING;
	const int out_cols = cols - PADDING;

	for (int cp = 0; cp < 16 * 16; cp++)
		LOC_PAT[cp] = pat[cp];
	barrier(CLK_LOCAL_MEM_FENCE);

	// Copy this work groups's image work area to local memory
	int lr, lc = col % LOC_COLS;
	unsigned char val;
	for (int cr = row; cr < (row + 8); cr++){
			lr = cr - row;
			val = GET(img, cols, cr, col);
			SET(LOC_IMG, LOC_COLS, lr, lc, val);

//			val = GET(LOC_IMG, LOC_COLS, lr, lc);
//			SET(out, out_cols, cr, col, val);
	}
	barrier(CLK_LOCAL_MEM_FENCE);

//	for (int cr = row; cr < (row + LOC_ROWS); cr+=8){
//		lr = cr - row;
//		val = GET(LOC_IMG, LOC_COLS, lr, lc);
//		SET(out, out_cols, cr, col, 255);
//	}

	int out_row;
	for (int r = 0; r < 32; r++) {
		out_row = row + r;

		//val = local_match_patt(LOC_IMG, LOC_PAT, 32, r, col);

		val = GET(LOC_IMG, LOC_COLS, 1, 1);

		SET(out, out_cols, out_row, col, val);
	}

}

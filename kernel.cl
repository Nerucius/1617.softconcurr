#include "common.h"
#include "kernel_core.c"

#define FACTOR 4096
#define LOC_ROWS 64
#define LOC_COLS 64
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
	__local  unsigned char LOC_IMG[LOC_SIZE];
		
	unsigned char val;
	unsigned short cc, cr;
	
	// Kernel row and col
	int row = get_global_id(1) * 8;	
	int col = get_global_id(0);
	const int out_rows = rows - PADDING;
	const int out_cols = cols - PADDING;
	
	// 0,0 image coordinates for this work-group
	const int irow = get_local_size(1) * get_group_id(1);
	const int icol = get_local_size(0) * get_group_id(0);
	
	int lr = get_local_id(1);
	int lc = get_local_id(0);
	
	// Copy Pattern
	if(lc < 16)
		for (cr = 0; cr < 16; cr++){
			val = GET(pat, 16, cr, lc);
			SET(LOC_PAT, 16, cr, lc, val);
			//LOC_PAT[lc * cr] = pat[lc * cr];
		}
	barrier(CLK_LOCAL_MEM_FENCE);
	
	
	int roff;
	int coff;
	
	// Copy the four 32x32 tiles composing our 64x64 local image copy
	for(roff = 0; roff <= 32; roff+=32){
		for(coff = 0; coff <= 32; coff+=32){
			row += roff;
			col += coff;
			lc += coff;
			for(int cr = row; cr < row +8; cr++){
				val = GET(img, cols, cr, col);
				lr = get_local_id(1)*8 + (cr - row) + roff;
				SET(LOC_IMG, LOC_COLS, lr, lc, val);
			}
			row -= roff;
			col -= coff;
			lc -= coff;
		}
	}	
	barrier(CLK_LOCAL_MEM_FENCE);
	

	for(int cr = row; cr < row +8; cr++){
		lr = get_local_id(1)*8 + (cr - row);
		val = GET(LOC_IMG, LOC_COLS, lr, lc);
		
		val = local_match_patt(LOC_IMG, LOC_PAT, LOC_COLS, lr, lc);
		SET(out, out_cols, cr, col, val );
	}
	
}

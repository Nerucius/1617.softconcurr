#include "common.h"

#define GET(img, cols, i, j)    (( img[i*cols + j] ))
#define SET(img, cols, i, j, v) ({ img[i*cols + j] = v; })

/** Clamp a float value between upper and lower bounds */
inline float fclamp(float val, float lower, float upper) {
	return max(min(upper, val), lower);
}

/** Match the pattern on a single pixel coordinate */
float match_patt(
		__global unsigned char *img,
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
	sum = fclamp(sum / (16 * 16 * 16), 0, 255);
	return sum;
}



// img: imatge amb una vora de 15 pixels per la dreta i per sota
// pat: patro de 16 x 16 pixels
// rows: files de img (incloent la vora de 15 pixels)
// cols: columnes de img (incloent la vora de 15 pixels)
// out: image resultant sense cap vora


__kernel void pattern_matching(
		__global unsigned char *img,
		__global unsigned char *pat,
		int rows,
		int cols,
		__global float *out) {
	__local unsigned char LOC_PAT[16 * 16];

	int i, j;
	float val;

	i = get_global_id(1) * 8;
	j = get_global_id(0);

	int out_rows = rows - PADDING;
	int out_cols = cols - PADDING;

	for (int cp = 0; cp < 16 * 16; cp++)
		LOC_PAT[cp] = pat[cp];
	barrier(CLK_LOCAL_MEM_FENCE);


	for (int row = 0; row < 8; row++) {
		int r = i + row;
		val = match_patt(img, LOC_PAT, cols, r, j);
		SET(out, out_cols, r, j, val);
	}

}

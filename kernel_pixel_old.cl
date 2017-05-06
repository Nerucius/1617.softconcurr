#include "common.h"

float getValue(__global unsigned char *img, int cols, int i, int j) {
	// i -> fila
	// j -> columna
	return img[i * cols + j];
}

void setValue(__global float *out, int cols, int i, int j, float value) {
	// i -> fila
	// j -> columna
	out[i * cols + j] = value;
}

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
			diff = getValue(img, cols, i + py, j + px) - getValue(pat, 16, py, px);
			sum += diff * diff;
		}
	}

	sum = sum / (float) (16 * 16);

	//sum = fclamp(sum, 0, 255);

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
	int i, j;
	char val;

	i = get_global_id(1);
	j = get_global_id(0);

	int out_rows = rows - PADDING;
	int out_cols = cols - PADDING;

	// Match the pattern
	val = match_patt(img, pat, cols, i, j);
	//val = getValue(img, cols, i, j);

	// Write value to out image
	setValue(out, out_cols, i, j, val);
}




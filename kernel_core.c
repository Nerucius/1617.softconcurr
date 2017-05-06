// Core functions for all kernels

#define GET(img, cols, i, j)    (( img[i*cols + j] ))
#define SET(img, cols, i, j, v) ({ img[i*cols + j] = v; })

/** Clamp a float value between upper and lower bounds */
inline float fclamp(float val, float lower, float upper) {
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



#include "common.h"
#include "kernel_core.c"

/**
 * PER ROW KERNEL: USING ONE WORK-ITEM PER PIXEL ROW. THE GLOBAL WORK
 * SIZE IS EQUAL TO THE HEIGHT OF THE IMAGE IN PIXELS.
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

    char val;
    int col, row;

    row = get_global_id(0);

    int out_rows = rows - PADDING;
    int out_cols = cols - PADDING;

    for (col = 0; col < out_cols; col++) {
        val = match_patt(img, pat, cols, row, col);
        // Write value to out image
        SET(out, out_cols, row, col, val);
    }
}




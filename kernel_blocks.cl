#include "common.h"
#include "kernel_core.c"

/**
 * 32x32 IMAGE BLOCKS KERNEL: USING 32x4 THREAD PER BLOCK.
 * EACH WORK-ITEM DOES A 8 PIXEL COLUMN OF THE IMAGE.
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
        __global float *out)
{
    __local unsigned char LOC_PAT[16*16];

    int i, j;
    float val;

    i = get_global_id(1)*8;
    j = get_global_id(0);

    int out_rows = rows - PADDING;
    int out_cols = cols - PADDING;

    // Each work item takes care of 8 vertical pixels
    for(int row = 0; row < 8; row ++){
        int r = i+row;
        val = match_patt(img, pat, cols, r, j);
        SET(out, out_cols, r, j, val);
    }

}

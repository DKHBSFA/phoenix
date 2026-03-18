// BitNet MAD (multiply-add-dot) kernel declarations
// I2_S ternary weight × I8_S int8 activation dot products
#pragma once

#include "ggml.h"

#ifdef __cplusplus
extern "C" {
#endif

// Quantize float weights to I2_S packed 2-bit ternary format
size_t quantize_i2_s(const float * GGML_RESTRICT src, void * GGML_RESTRICT dst,
                     int64_t nrow, int64_t n_per_row, const float * quant_weights);

// I2_S × I8_S dot product (auto-dispatches to best variant)
void ggml_vec_dot_i2_i8_s(int n, float * GGML_RESTRICT s, size_t bs,
                          const void * GGML_RESTRICT vx, size_t bx,
                          const void * GGML_RESTRICT vy, size_t by, int nrc);

#ifdef __cplusplus
}
#endif

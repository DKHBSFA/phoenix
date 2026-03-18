// Minimal ggml-bitnet.h stub for ggml-bitnet-mad.cpp
// The full BitNet TL1/TL2 lookup-table API is not needed for MAD kernels.
#pragma once

#include "ggml.h"

#ifdef __ARM_NEON
#include <arm_neon.h>
typedef float32_t bitnet_float_type;
#else
typedef float bitnet_float_type;
#endif

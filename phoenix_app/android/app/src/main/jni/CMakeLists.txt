cmake_minimum_required(VERSION 3.22.1)
project(bitnet_phoenix)

# ─── Build configuration ─────────────────────────────────────────
# CPU-only build for Android
set(GGML_METAL  OFF CACHE BOOL "" FORCE)
set(GGML_CUDA   OFF CACHE BOOL "" FORCE)
set(GGML_VULKAN OFF CACHE BOOL "" FORCE)
set(GGML_OPENMP OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_COMMON   ON  CACHE BOOL "" FORCE)
set(LLAMA_CURL           OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_TESTS    OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(LLAMA_BUILD_SERVER   OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS    OFF CACHE BOOL "" FORCE)

# Disable assertions in ggml (NaN assertions crash on some devices)
add_compile_definitions(NDEBUG)

# CRITICAL: Force -O3 for llama.cpp even in debug Flutter builds.
# Without this, matrix math runs 40x slower (-O0 vs -O3 with NEON).
set(CMAKE_C_FLAGS_DEBUG "-O3 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "-O3 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "" FORCE)

# Build upstream llama.cpp with I2_S patches
add_subdirectory(llama.cpp)

# Phoenix bridge — wraps llama.cpp for Dart FFI
add_library(bitnet SHARED phoenix_bridge.cpp)

target_include_directories(bitnet PRIVATE
    ${CMAKE_SOURCE_DIR}/llama.cpp/include
    ${CMAKE_SOURCE_DIR}/llama.cpp/common
    ${CMAKE_SOURCE_DIR}/llama.cpp/ggml/include
)

target_compile_options(bitnet PRIVATE -O3 -DNDEBUG)

# Link llama.cpp libraries + Android log
find_library(log-lib log)
target_link_libraries(bitnet
    llama
    common
    ${log-lib}
)

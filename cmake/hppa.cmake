set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR hppa)

# COMPILERS
# ---------
SET(CMAKE_C_COMPILER hppa-linux-gnu-gcc-10)
SET(CMAKE_CXX_COMPILER hppa-linux-gnu-g++-10)
set(CMAKE_COMPILER_PREFIX hppa-linux-gnu-)

# PATHS
# -----
set(CMAKE_FIND_ROOT_PATH /usr/hppa-linux-gnu/)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# OTHER
# -----
set(ARCH 32)
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")

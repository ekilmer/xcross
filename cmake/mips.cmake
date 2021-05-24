set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR mips)

# COMPILERS
# ---------
SET(CMAKE_C_COMPILER mips-linux-gnu-gcc-10)
SET(CMAKE_CXX_COMPILER mips-linux-gnu-g++-10)
set(CMAKE_COMPILER_PREFIX mips-linux-gnu-)

# PATHS
# -----
set(CMAKE_FIND_ROOT_PATH /usr/mips-linux-gnu/)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# OTHER
# -----
set(ARCH 32)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mabi=32")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static -mabi=32")

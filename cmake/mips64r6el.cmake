set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR mipsisa64r6el)

# COMPILERS
# ---------
SET(CMAKE_C_COMPILER mipsisa64r6el-linux-gnuabi64-gcc-10)
SET(CMAKE_CXX_COMPILER mipsisa64r6el-linux-gnuabi64-g++-10)
set(CMAKE_COMPILER_PREFIX mipsisa64r6el-linux-gnuabi64-)

# PATHS
# -----
set(CMAKE_FIND_ROOT_PATH /usr/mipsisa64r6el-linux-gnuabi64/)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# OTHER
# -----
set(ARCH 64)
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")

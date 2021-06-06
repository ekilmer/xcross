#!/bin/bash
# Simple shortcuts to call executables.

BIN=/usr/local/bin

# Can't guarantee all files are compiled binaries, might be
# scripts that use positional arguments. Make it a script
# that called the argument. Only export shortcut if the
# command exists, which may either be a command in the path,
# or an absolute path.
shortcut() {
    if command -v "$1" &> /dev/null; then
        echo '#!/bin/bash' >> "$2"
        echo "args=\"$ARGS\"" >> "$2"
        for value in "${FLAGS[@]}"; do
            local flag="${value%\/*}"
            local ident="${value#*\/}"
            echo "if [ \"\$$ident\" != \"\" ]; then" >> "$2"
            echo "    args=\"\$args $flag\$$ident\"" >> "$2"
            echo "fi" >> "$2"
        done
        echo "$1 \$args \"\$@\"" >> "$2"
        chmod +x "$2"
        for file in "${@:3}"; do
            ln -s "$2" "$file"
        done
    fi
}

# Create a utility to list the CPUs for the compiler.
shortcut_cc_cpu_list() {
    echo '#!/bin/bash' >> "$BIN/cc-cpu-list"
    echo "cpus=\$(echo \"int main() { return 0; }\" | CPU=unknown c++ -x c++ - 2>&1)" >> "$BIN/cc-cpu-list"
    echo "filtered=\$(echo \"\$cpus\" | grep note)" >> "$BIN/cc-cpu-list"
    echo "names=(\${filtered#* are: })" >> "$BIN/cc-cpu-list"
    echo "IFS=$'\n' sorted=(\$(sort <<<\"\${names[*]}\"))" >> "$BIN/cc-cpu-list"
    echo "echo \"\${sorted[@]}\"" >> "$BIN/cc-cpu-list"
    chmod +x "$BIN/cc-cpu-list"
}

# Generate the shortcut for any compiler.
shortcut_compiler() {
    local cc_base="$1"
    local cxx_base="$2"

    local prefix
    if [ "$DIR" = "" ]; then
        prefix="$PREFIX"
    else
        prefix="$DIR/bin/$PREFIX"
    fi

    local cc="$cc_base"
    local cxx="$cxx_base"
    if [ "$PREFIX" != "" ]; then
        cc="$prefix"-"$cc"
        cxx="$prefix"-"$cxx"
    fi

    # -mcpu is deprecated on x86.
    local cpu="mcpu"
    if [[ "$PREFIX" = i[3-7]86-* ]] || [[ "$PREFIX" = x86_64-* ]] || [ "$PREFIX" = "" ]; then
        cpu="march"
    fi
    # only -march works on MIPS architectures.
    if [[ "$PREFIX" = mips* ]]; then
        cpu="march"
    fi

    cc_alias=("$BIN/$cc_base" "$BIN/cc")
    cxx_alias=("$BIN/$cxx_base" "$BIN/c++" "$BIN/cpp")
    ARGS="$CFLAGS" FLAGS="-$cpu=/CPU" shortcut "$cc" "${cc_alias[@]}"
    ARGS="$CFLAGS" FLAGS="-$cpu=/CPU" shortcut "$cxx" "${cxx_alias[@]}"

    if [ "$VER" != "" ]; then
        ARGS="$CFLAGS" FLAGS="-$cpu=/CPU" shortcut "$cc"-"$VER" "${cc_alias[@]}"
        ARGS="$CFLAGS" FLAGS="-$cpu=/CPU" shortcut "$cxx"-"$VER" "${cxx_alias[@]}"
    fi
    shortcut_cc_cpu_list
}

# Shortcut for a GCC-based compiler.
shortcut_gcc() {
    shortcut_compiler "gcc" "g++"
}

# Shortcut for a Clang-based compiler.
shortcut_clang() {
    shortcut_compiler "clang" "clang++"
}

# Shortcut for all the utilities.
shortcut_util() {
    if [ "$PREFIX" = "" ]; then
        echo "Error: must set a prefix for the utilities."
        exit 1
    fi

    local prefix
    if [ "$DIR" = "" ]; then
        prefix="$PREFIX"
    else
        prefix="$DIR/bin/$PREFIX"
    fi

    # Make arrays of all our arguments.
    local ver_utils=("gcov" "gcov-dump" "gcov-tool" "lto-dump")
    local utils=(
        "${ver_utils[@]}"
        "addr2line"
        "ar"
        "as"
        "c++filt"
        "dwp"
        "elfedit"
        "embedspu"
        "gcov"
        "gcov-dump"
        "gcov-tool"
        "gprof"
        "ld"
        "ld.bfd"
        "ld.gold"
        "lto-dump"
        "nm"
        "objcopy"
        "objdump"
        "ranlib"
        "readelf"
        "size"
        "strings"
        "strip"
    )

    # Some of these might not exist, but it's fine.
    # Shortcut does nothing if the file doesn't exist.
    for util in "${utils[@]}"; do
        shortcut "$prefix"-"$util" "$BIN/$util"
    done
    if [ "$VER" != "" ]; then
        for util in "${ver_utils[@]}"; do
            shortcut "$prefix"-"$util"-"$VER" "$BIN/$util"
        done
    fi
}

# Create a utility to list the CPUs for Qemu emulation.
shortcut_run_cpu_list() {
    echo '#!/bin/bash' >> "$BIN/run-cpu-list"
    echo "cpus=\"\$(run -cpu help)\"" >> "$BIN/run-cpu-list"
    echo "readarray -t lines <<<\"\$cpus\"" >> "$BIN/run-cpu-list"
    echo "names=()" >> "$BIN/run-cpu-list"
    echo "for line in \"\${lines[@]:1}\"; do" >> "$BIN/run-cpu-list"
    echo "    if [ \"\$line\" != \"\" ]; then" >> "$BIN/run-cpu-list"
    echo "        names+=(\$(echo \"\$line\" | cut -d ' ' -f 2))" >> "$BIN/run-cpu-list"
    echo "    else" >> "$BIN/run-cpu-list"
    echo "        break" >> "$BIN/run-cpu-list"
    echo "    fi" >> "$BIN/run-cpu-list"
    echo "done" >> "$BIN/run-cpu-list"
    echo "" >> "$BIN/run-cpu-list"
    echo "IFS=$'\n' sorted=(\$(sort <<<\"\${names[*]}\"))" >> "$BIN/run-cpu-list"
    echo "echo \"\${sorted[@]}\"" >> "$BIN/run-cpu-list"
    chmod +x "$BIN/run-cpu-list"
}

# Create a runner for the Qemu binary.
shortcut_run() {
    if [ "$ARCH" = "" ]; then
        echo "Error: Architecture for Qemu must be specified."
        exit 1
    fi

    local args=
    if [ "$LIBPATH" != "" ]; then
        # Add support for executables linked to a shared libc/libc++.
        for libpath in "${LIBPATH[@]}"; do
            args="$args -L $libpath"
        done
    fi
    FLAGS="-cpu /CPU" ARGS="$args" shortcut "qemu-$ARCH-static" "$BIN/run"
    shortcut_run_cpu_list
}

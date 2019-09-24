# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Spot"
version = v"2.8.1"

# Collection of sources required to build SpotBuilder
sources = [
    "http://www.lrde.epita.fr/dload/spot/spot-2.8.1.tar.gz" =>
    "dcb7aa684725304afb3d435f26f25b51fbd6e9a6ef610e16163cc0030ad5eab4"    
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd spot-2.8.1

if [[ "${target}" == *-freebsd* ]] || [[ "${target}" == *-apple-* ]]; then
    export FC=/opt/${target}/bin/${target}-gfortran
    export LD=/opt/${target}/bin/${target}-ld
    export AR=/opt/${target}/bin/${target}-ar
    export AS=/opt/${target}/bin/${target}-as
    export NM=/opt/${target}/bin/${target}-nm
    export OBJDUMP=/opt/${target}/bin/${target}-objdump
fi

./configure --prefix=$prefix --host=${target} --disable-python
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)),
    Linux(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    Linux(:x86_64, compiler_abi=CompilerABI(:gcc8)),
    MacOS()
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libspot", :libspot)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

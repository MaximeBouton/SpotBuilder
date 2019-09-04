# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Spot"
version = v"2.7.5"

# Collection of sources required to build SpotBuilder
sources = [
    "http://www.lrde.epita.fr/dload/spot/spot-2.7.5.tar.gz" =>
    "2cbbfb6245250603c92fd3d512d07b5d70c7924826b156a260c4a41039c0ce23",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd spot-2.7.5

if [[ "${target}" == *-freebsd* ]] || [[ "${target}" == *-apple-* ]]; then
    export CC=/opt/${target}/bin/${target}-gcc
    export CXX=/opt/${target}/bin/${target}-g++
    export FC=/opt/${target}/bin/${target}-gfortran
    export LD=/opt/${target}/bin/${target}-ld
    export AR=/opt/${target}/bin/${target}-ar
    export AS=/opt/${target}/bin/${target}-as
    export NM=/opt/${target}/bin/${target}-nm
    export OBJDUMP=/opt/${target}/bin/${target}-objdump
fi

./configure --prefix=$prefix --host=${target} --disable-python
sed -i 's/<cstdlib>/<stdlib.h>/' spot/misc/tmpfile.cc
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    Linux(:x86_64, compiler_abi=CompilerABI(:gcc7)),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7))
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

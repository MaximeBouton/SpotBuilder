# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "Spot"
version = v"2.6.3"

# Collection of sources required to build SpotBuilder
sources = [
    "https://gitlab.lrde.epita.fr/spot/spot/-/jobs/21743/artifacts/download" =>
    "c9ec44d4379522a83740f5aaae34bc48a9e7c88abef6d37b168bd135fc43dcea",
]

# Bash recipe for building across all platforms
script = raw"""
apk add python3-dev
cd $WORKSPACE/srcdir
unzip download 
tar -xzf spot-2.6.3.dev.tar.gz
cd spot-2.6.3.dev 
./configure --prefix=$prefix --host=${target}
sed -i 's/<cstdlib>/<stdlib.h>/' spot/misc/tmpfile.cc
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, compiler_abi=CompilerABI(:gcc7))
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "spot", :spot)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)


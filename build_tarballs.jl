# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "SpotBuilder"
version = v"0.0.0"

# Collection of sources required to build SpotBuilder
sources = [
    "https://gitlab.lrde.epita.fr/spot/spot/-/jobs/21303/artifacts/download" =>
    "5f60a22b5d92eaaa032698a8697fac9e95e9c2649f0604d381ccceebfa65c8c2",

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


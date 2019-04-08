using BinaryBuilder

# Collection of sources required to build Gettext
sources = [
    "https://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.tar.xz" =>
    "9c1781328238caa1685d7bc7a2e1dcf1c6c134e86b42ed554066734b621bd12f",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd gettext-0.19.8/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.Linux(:aarch64, :glibc),
    BinaryProvider.Linux(:armv7l, :glibc),
    BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS(),
    # Gettext fails on windows when it can't find iconv.h
    #BinaryProvider.Windows(:i686),
    #BinaryProvider.Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgettext", :libgettext)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libgettext", sources, script, platforms, products, dependencies)


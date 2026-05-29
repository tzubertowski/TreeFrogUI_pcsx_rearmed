#!/bin/bash
# Build pcsx_rearmed libretro core for SF3000 (MIPS32r2), interpreter only.
# No lightrec / no dynarec (DYNAREC=0) — lightrec MIPS backend not used for now.
# Uses the SF3000 compiler wrappers (embed mips32r2/sysroot/Ofast) so the
# Makefile's own -Iinclude etc. are preserved (don't pass CFLAGS= wholesale).
set -e
cd "$(dirname "$0")"

WRAP="$HOME/sf3000-work/sf3000_treefrogui/.toolchain"
CC="$WRAP/mips-gcc"
CXX="$WRAP/mips-g++"
TC="$HOME/sf3000-work/sf3000toolchain/mipsel-buildroot-linux-gnu_sdk-buildroot/opt/ext-toolchain/bin/mips-mti-linux-gnu-"

make -f Makefile.libretro clean 2>/dev/null || true

make -f Makefile.libretro platform=unix \
    CC="$CC" CXX="$CXX" CC_AS="$CC" CC_LINK="$CXX" \
    AR="${TC}ar" \
    ARCH=mips DYNAREC=0 HAVE_NEON=0 BUILTIN_GPU=unai \
    -j"$(nproc)"

ls -la pcsx_rearmed_libretro.so
file pcsx_rearmed_libretro.so
echo "=== BUILD DONE ==="

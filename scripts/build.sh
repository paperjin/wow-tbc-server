#!/bin/bash
# Build mangosd with playerbots on Steam Deck
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$PROJECT_DIR/source"
BUILD_DIR="$SOURCE_DIR/build"
INSTALL_DIR="$SOURCE_DIR/install"

echo "=== Building CMaNGOS TBC + Playerbots ==="
echo "Source: $SOURCE_DIR"
echo "Build:  $BUILD_DIR"
echo ""

# Create build directory
mkdir -p "$BUILD_DIR" "$INSTALL_DIR"

# Configure
cd "$BUILD_DIR"
cmake "$SOURCE_DIR/mangos-tbc" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    -DPCH=1 \
    -DBUILD_PLAYERBOTS=ON \
    -DPLAYERBOTS_SOURCE_DIR="$SOURCE_DIR/playerbots" \
    -DDEBUG=0

# Build
echo ""
echo "=== Building mangosd ==="
make -j$(nproc) mangosd

echo ""
echo "=== Build complete ==="
echo "Binary: $BUILD_DIR/src/mangosd/mangosd"

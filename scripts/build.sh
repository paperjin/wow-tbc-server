#!/bin/bash
# Build mangosd with playerbots using multi-stage Docker build
# IMPORTANT: Must build inside the Ubuntu 24.04 base image to match libs
set -e

SCRIPT_DIR=/bin
PROJECT_DIR=.

echo === Building tbc-server:local ===
echo Project: 
echo 

cd 

# Apply patches first
echo === Applying patches ===
cd source/mangos-tbc
git apply ../../patches/002-core-selfbot-fixes.patch 2>/dev/null || echo Already applied
git apply ../../patches/003-20x-bg-marks.patch 2>/dev/null || echo Already applied
cd ../playerbots
git apply ../../patches/001-selfbot-bg-fixes.patch 2>/dev/null || echo Already applied
git apply ../../patches/006-playerbot-factory-infinite-loop.patch 2>/dev/null || echo Already applied
git apply ../../patches/007-cloth-armor-fallback.patch 2>/dev/null || echo Already applied
git apply ../../patches/008-rpg-flag-persistence-fix.patch 2>/dev/null || echo Already applied
git apply ../../patches/009-arena2v2-support.patch 2>/dev/null || echo Already applied
cd ../..

# Also apply playerbot patches to the embedded copy in mangos-tbc (cmake uses this one, not the separate dir)
echo === Applying patches to embedded playerbots ===
cd source/mangos-tbc/src/modules/PlayerBots
git apply ../../../../../patches/001-selfbot-bg-fixes.patch 2>/dev/null || echo Already applied
git apply ../../../../../patches/006-playerbot-factory-infinite-loop.patch 2>/dev/null || echo Already applied
git apply ../../../../../patches/007-cloth-armor-fallback.patch 2>/dev/null || echo Already applied
git apply ../../../../../patches/008-rpg-flag-persistence-fix.patch 2>/dev/null || echo Already applied
git apply ../../../../../patches/009-arena2v2-support.patch 2>/dev/null || echo Already applied
cd ../../../../..

# Apply cmake fix to mangos-tbc (replace FetchContent with add_subdirectory)
echo === Applying cmake fix ===
cd source/mangos-tbc
git apply ../../patches/010-cmake-fetchcontent-fix.patch 2>/dev/null || echo Already applied
cd ../..

# Build the image
echo 
echo === Building container image ===
podman build --security-opt label=disable -t tbc-server:local -f Dockerfile .

echo 
echo === Build complete ===
echo Image: tbc-server:local
echo To deploy: podman compose up -d

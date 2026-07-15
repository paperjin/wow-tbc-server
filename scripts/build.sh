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
git apply ../../patches/005-mount-interrupt-fix.patch 2>/dev/null || echo Already applied
git apply ../../patches/006-playerbot-factory-infinite-loop.patch 2>/dev/null || echo Already applied
git apply ../../patches/007-cloth-armor-fallback.patch 2>/dev/null || echo Already applied
cd ../..

# Build the image
echo 
echo === Building container image ===
podman build --security-opt label=disable -t tbc-server:local -f Dockerfile .

echo 
echo === Build complete ===
echo Image: tbc-server:local
echo To deploy: podman compose up -d

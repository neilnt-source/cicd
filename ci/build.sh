#!/usr/bin/env bash
set -Eeuo pipefail

echo "=== Embedded CI demo build ==="
echo "Build host: $(uname -a)"
echo "Compiler:"
gcc --version | head -n 1

mkdir -p output
cat > output/build-info.txt <<INFO
Project: prpl-router-ci-demo
Build date (UTC): $(date -u +%FT%TZ)
Build host: $(hostname)
INFO

echo "=== Build complete ==="

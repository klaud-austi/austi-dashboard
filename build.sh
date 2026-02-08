#!/bin/bash
# Build static dashboard - now just copies HTML, tasks fetched live from GitHub
cd "$(dirname "$0")"
mkdir -p dist
cp static/index.html dist/index.html
echo "Built dashboard (tasks fetched live from GitHub)"

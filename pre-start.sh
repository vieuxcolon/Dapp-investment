#!/bin/bash
# pre-start.sh
# ================================
# Prepares Docker environment and ensures all dependencies are correct
# ================================

set -e

echo "=========================================="
echo "Pre-Start Script - Dapp Investment"
echo "=========================================="

# Run pre-check
echo "[INFO] Running pre-check.sh"
./pre-check.sh

# Build backend Docker image (no cache)
echo "[INFO] Building backend Docker image (no cache)..."
docker build --no-cache \
  -t dapp-backend \
  -f docker/backend.Dockerfile \
  .

# Build frontend Docker image (no cache)
echo "[INFO] Building frontend Docker image (no cache)..."
docker build --no-cache \
  -t dapp-frontend \
  -f docker/frontend.Dockerfile \
  .

echo "=========================================="
echo "Pre-start completed successfully!"
echo "You can now run ./start.sh to launch the Dapp"
echo "=========================================="

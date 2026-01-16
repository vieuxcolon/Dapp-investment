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

# Ensure Docker images are built
echo "[INFO] Building backend Docker image..."
docker build -t dapp-backend -f backend.Dockerfile ./backend

echo "[INFO] Building frontend Docker image..."
docker build -t dapp-frontend -f frontend.Dockerfile ./frontend

echo "=========================================="
echo "Pre-start completed successfully!"
echo "You can now run ./start.sh to launch the Dapp"
echo "=========================================="

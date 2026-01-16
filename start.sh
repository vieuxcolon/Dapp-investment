#!/bin/bash
# start.sh
# ================================
# Launches backend and frontend using Docker Compose
# ================================

set -e

echo "=========================================="
echo "Starting Dapp Investment (Docker Compose)"
echo "=========================================="

# Ensure pre-start has been run
if [ ! -d "backend/node_modules" ] || [ ! -d "frontend/node_modules" ]; then
  echo "[WARN] Dependencies not installed. Running pre-start.sh first..."
  ./pre-start.sh
fi

# Pass .env file explicitly to Docker Compose
echo "[INFO] Launching Docker Compose (no cache)..."
docker-compose --env-file .env up --build --no-cache

echo "=========================================="
echo "Dapp Investment started successfully!"
echo "=========================================="

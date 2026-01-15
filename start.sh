#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

echo "Step 1: Build and start backend + frontend containers..."
docker-compose up --build -d

echo "Step 2: Wait 5 seconds for backend container to be ready..."
sleep 5

echo "Step 3: Run pre-start to compile contracts and export ABIs..."
./pre-start.sh

echo "Step 4: Start frontend container (detached)"
docker-compose up -d frontend

echo "=========================================="
echo "All services should now be running!"
echo "Frontend: http://localhost:3000"
echo "Hardhat node: http://localhost:8545"
echo "=========================================="

echo "Connect MetaMask to localhost:8545 and import PRIVATE_KEY to test the DApp."

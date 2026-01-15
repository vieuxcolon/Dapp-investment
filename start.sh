#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Build Docker images
echo "Step 1: Building backend and frontend Docker images..."
docker-compose build

# Step 2: Start backend container (Hardhat node)
echo "Step 2: Starting backend container..."
docker-compose up -d backend

# Wait for Hardhat node to initialize
echo "Waiting 5 seconds for Hardhat node..."
sleep 5

# Step 3: Compile contracts & export ABIs to frontend
echo "Step 3: Compiling contracts and exporting ABIs..."
./pre-start.sh

# Step 4: Start frontend container
echo "Step 4: Starting frontend container..."
docker-compose up -d frontend

echo "=========================================="
echo "All services are running!"
echo "Frontend: http://localhost:3000"
echo "Hardhat node RPC: http://localhost:8545"
echo "=========================================="

echo "MetaMask setup:"
echo "1. Add a network pointing to http://localhost:8545"
echo "2. Import PRIVATE_KEY from .env (e.g., Hardhat account #0)"
echo "3. Ready to test DAO proposal submission, voting, and execution!"

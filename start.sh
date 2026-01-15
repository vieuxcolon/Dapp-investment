#!/bin/bash
set -e

echo "Building Docker containers..."
docker-compose build

echo "Starting backend (Hardhat node)..."
docker-compose up -d backend

# Wait for backend to be ready
echo "Waiting 5 seconds for Hardhat node to start..."
sleep 5

echo "Deploying contracts..."
docker exec -it $(docker ps -qf "name=dapp-investment_backend_1") npx hardhat run scripts/deploy.js --network localhost

echo "Starting frontend..."
docker-compose up -d frontend

echo "DApp is running!"
echo "Frontend: http://localhost:3000"
echo "Backend (Hardhat node): http://localhost:8545"

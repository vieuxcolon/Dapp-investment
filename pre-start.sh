#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: compiling contracts and exporting ABIs..."
echo "=========================================="

# Make sure backend container is running
if ! docker ps --format '{{.Names}}' | grep -q "dao-backend"; then
  echo "Backend container not running. Starting it in detached mode..."
  docker-compose up -d backend
  echo "Waiting 5 seconds for backend container to be ready..."
  sleep 5
fi

# Run compilation inside backend container
docker exec -i dao-backend /bin/bash -c "
cd /app/backend
echo 'Running Hardhat compile...'
npx hardhat compile
echo 'Copying ABIs to frontend...'
cp artifacts/contracts/DAOToken.sol/DAOToken.json ../frontend/src/contracts/
cp artifacts/contracts/Governance.sol/Governance.json ../frontend/src/contracts/
cp artifacts/contracts/Treasury.sol/Treasury.json ../frontend/src/contracts/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json ../frontend/src/contracts/
"

echo "Pre-start completed: ABIs exported!"

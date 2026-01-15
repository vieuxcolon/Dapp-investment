#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: compiling contracts and exporting ABIs..."
echo "=========================================="

# Ensure backend container is running
if ! docker ps --format '{{.Names}}' | grep -q "dao-backend"; then
  echo "Backend container not running. Starting..."
  docker compose up -d backend
  sleep 15
fi

# Compile contracts inside backend container and export ABIs
docker exec -i dao-backend /bin/bash -c "
cd /app/backend
echo 'Running Hardhat compile...'
npx hardhat compile
echo 'Copying contract ABIs to frontend...'
cp artifacts/contracts/DAOToken.sol/DAOToken.json ../frontend/src/contracts/
cp artifacts/contracts/Governance.sol/Governance.json ../frontend/src/contracts/
cp artifacts/contracts/Treasury.sol/Treasury.json ../frontend/src/contracts/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json ../frontend/src/contracts/
"

echo " Pre-start complete: ABIs exported!"

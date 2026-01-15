#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: installing backend dependencies, compiling contracts and exporting ABIs..."
echo "=========================================="

cd backend

# 1. Ensure deterministic backend dependencies
if [ ! -f package-lock.json ]; then
  echo "[INFO] No package-lock.json found. Running npm install..."
  npm install --legacy-peer-deps
else
  echo "[INFO] package-lock.json found. Running npm ci for deterministic install..."
  npm ci --legacy-peer-deps
fi

# 2. Compile contracts
npx hardhat compile

# 3. Export ABIs to frontend
FRONTEND_CONTRACT_DIR="../frontend/src/contracts"
mkdir -p $FRONTEND_CONTRACT_DIR

cp artifacts/contracts/DAOToken.sol/DAOToken.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Governance.sol/Governance.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Treasury.sol/Treasury.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json $FRONTEND_CONTRACT_DIR/

echo "[INFO] ABIs exported to frontend."

#!/bin/bash
set -e

echo "========================================================="
echo "Pre-start: compiling contracts and exporting ABIs..."
echo "========================================================="

# ----------------------------
# 1. Compile contracts
# ----------------------------
cd backend

#  NO npm install here
npx hardhat compile

cd - >/dev/null

# ----------------------------
# 2. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"
mkdir -p "$FRONTEND_CONTRACT_DIR"

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[OK] ABIs exported to frontend."

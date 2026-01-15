#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: deterministic backend install, compile, export ABIs"
echo "=========================================="

BACKEND_DIR="./backend"
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"

# Clean node_modules and lockfile
rm -rf $BACKEND_DIR/node_modules $BACKEND_DIR/package-lock.json

cd $BACKEND_DIR

echo "[INFO] Installing deterministic backend dependencies..."
npm install --legacy-peer-deps

echo "[INFO] Compiling contracts..."
npx hardhat compile

cd - >/dev/null

echo "[INFO] Exporting ABIs to frontend..."
mkdir -p "$FRONTEND_CONTRACT_DIR"
cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[OK] ABIs exported successfully."

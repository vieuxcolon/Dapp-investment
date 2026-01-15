#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: compiling contracts and exporting ABIs..."
echo "=========================================="

cd backend

# Compile contracts
npx hardhat compile

# Export ABIs to frontend
FRONTEND_CONTRACT_DIR="../frontend/src/contracts"
mkdir -p $FRONTEND_CONTRACT_DIR

cp artifacts/contracts/DAOToken.sol/DAOToken.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Governance.sol/Governance.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Treasury.sol/Treasury.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json $FRONTEND_CONTRACT_DIR/

echo " ABIs exported to frontend."

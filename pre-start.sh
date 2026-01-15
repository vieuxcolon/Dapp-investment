#!/bin/bash
set -e

echo "Pre-start: compiling contracts and exporting ABIs..."

# Move to backend
cd backend

# Compile contracts
echo "Running Hardhat compile..."
npx hardhat compile

# Ensure frontend contracts directory exists
echo "Ensuring frontend ABI directory exists..."
mkdir -p ../frontend/src/contracts

# Copy ABIs to frontend
echo "Copying contract ABIs to frontend..."
cp artifacts/contracts/DAOToken.sol/DAOToken.json ../frontend/src/contracts/
cp artifacts/contracts/Governance.sol/Governance.json ../frontend/src/contracts/
cp artifacts/contracts/Treasury.sol/Treasury.json ../frontend/src/contracts/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json ../frontend/src/contracts/

echo "Pre-start completed successfully."

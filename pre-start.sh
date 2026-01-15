#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: compiling contracts and exporting ABIs..."
echo "=========================================="

# Load .env variables
export $(grep -v '^#' .env | xargs)

# Compile Hardhat contracts
cd backend
if ! command -v npx &> /dev/null
then
    echo "npx not found! Ensure Node.js and npm are installed."
    exit 1
fi

npx hardhat compile

# Export contract ABIs to frontend
FRONTEND_CONTRACT_DIR="../frontend/src/contracts"
mkdir -p $FRONTEND_CONTRACT_DIR

cp artifacts/contracts/DAOToken.sol/DAOToken.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Governance.sol/Governance.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/Treasury.sol/Treasury.json $FRONTEND_CONTRACT_DIR/
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json $FRONTEND_CONTRACT_DIR/

echo " ABIs exported to frontend."

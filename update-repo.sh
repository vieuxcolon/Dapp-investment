#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 2.x repo cleanup workflow"
echo "=========================================="

# ----------------------------
# 1. Remove legacy Hardhat 3.x config files
# ----------------------------
echo "[INFO] Removing legacy Hardhat 3.x config files..."
rm -f backend/hardhat.config.js
rm -f backend/package-lock.json
rm -rf backend/node_modules

# ----------------------------
# 2. Clean backend and install dependencies
# ----------------------------
echo "[INFO] Cleaning backend..."
cd backend

# Remove node_modules just in case
rm -rf node_modules

# If package-lock.json does not exist, generate it
if [ ! -f package-lock.json ]; then
    echo "[INFO] package-lock.json missing. Generating it..."
    npm install
fi

# Install deterministic dependencies
echo "[INFO] Installing deterministic Hardhat 2.x dependencies..."
npm ci

# Ensure Hardhat 2.x is installed
npm install --save-dev hardhat@^2.28.0 @nomiclabs/hardhat-ethers@^2.2.3

# Ensure OpenZeppelin Contracts is installed
if ! npm list @openzeppelin/contracts &>/dev/null; then
    echo "[INFO] Installing OpenZeppelin Contracts..."
    npm install @openzeppelin/contracts@^4.9.3 --save
fi

# ----------------------------
# 3. Create Hardhat config for HH2.x if missing
# ----------------------------
if [ ! -f hardhat.config.js ]; then
    echo "[INFO] Creating hardhat.config.js for HH2.x..."
    cat <<EOL > hardhat.config.js
require("@nomiclabs/hardhat-ethers");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.28",
};
EOL
fi

# ----------------------------
# 4. Compile contracts
# ----------------------------
echo "[INFO] Compiling Hardhat contracts..."
npx hardhat compile

# ----------------------------
# 5. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="../frontend/src/contracts"
mkdir -p "$FRONTEND_CONTRACT_DIR"

echo "[INFO] Exporting ABIs to frontend..."
cp artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

cd - >/dev/null

echo "=========================================="
echo "Hardhat 2.x repo update complete!"
echo "You can now run ./pre-start.sh and ./start.sh"
echo "=========================================="

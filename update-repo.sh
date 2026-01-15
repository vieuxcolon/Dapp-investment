#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

BACKEND_DIR="./backend"
FRONTEND_DIR="./frontend"

# 1️⃣ Backup old HH2.x files
echo "[INFO] Backing up old Hardhat 2.x files..."
mkdir -p ./backup_HH2
cp -r $BACKEND_DIR/package-lock.json ./backup_HH2/package-lock.json || true
cp -r $BACKEND_DIR/hardhat.config.js ./backup_HH2/hardhat.config.js || true
rm -rf $BACKEND_DIR/cache $BACKEND_DIR/artifacts

# 2️⃣ Clean backend node_modules
echo "[INFO] Cleaning backend node_modules..."
rm -rf $BACKEND_DIR/node_modules
rm -f $BACKEND_DIR/package-lock.json

# 3️⃣ Update backend package.json for HH3.x
echo "[INFO] Updating backend package.json for Hardhat 3.x..."
jq '.devDependencies.hardhat="^3.1.4"' $BACKEND_DIR/package.json > tmp.json && mv tmp.json $BACKEND_DIR/package.json
jq '.devDependencies["@nomicfoundation/hardhat-toolbox"]="^3.1.0"' $BACKEND_DIR/package.json > tmp.json && mv tmp.json $BACKEND_DIR/package.json
jq 'del(.devDependencies["@nomiclabs/hardhat-ethers"])' $BACKEND_DIR/package.json > tmp.json && mv tmp.json $BACKEND_DIR/package.json

# 4️⃣ Install HH3.x dependencies
echo "[INFO] Installing Hardhat 3.x and other dependencies..."
cd $BACKEND_DIR
npm install
npm install @openzeppelin/contracts

# 5️⃣ Generate new Hardhat 3.x config
echo "[INFO] Creating new Hardhat 3.x config..."
cat > hardhat.config.js <<EOL
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: { enabled: true, runs: 200 },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  networks: {
    hardhat: {},
  },
};

export default config;
EOL

# 6️⃣ Compile contracts
echo "[INFO] Compiling contracts with Hardhat 3.x..."
npx hardhat compile

echo "=========================================="
echo "Hardhat 3.x upgrade workflow completed successfully!"
echo "=========================================="

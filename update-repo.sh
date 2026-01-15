#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

# ------------------------
# 1. Backup old files
# ------------------------
BACKUP_DIR="backup_hh2_$(date +%Y%m%d%H%M%S)"
echo "[INFO] Backing up old Hardhat 2.x files to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r backend frontend contracts hardhat.config.js package*.json "$BACKUP_DIR" || true

# ------------------------
# 2. Ensure jq is installed
# ------------------------
if ! command -v jq &> /dev/null; then
    echo "[INFO] jq not found. Installing jq..."
    sudo apt update && sudo apt install -y jq
fi

# ------------------------
# 3. Clean node_modules and package-lock
# ------------------------
echo "[INFO] Cleaning backend node_modules and package-lock..."
rm -rf backend/node_modules backend/package-lock.json
rm -rf frontend/node_modules frontend/package-lock.json

# ------------------------
# 4. Detect latest Hardhat 3.x versions
# ------------------------
echo "[INFO] Detecting latest Hardhat 3.x versions..."
HH_VERSION=$(npm view hardhat versions --json | jq -r '.[] | select(test("^3"))' | tail -1)
TOOLBOX_VERSION=$(npm view @nomicfoundation/hardhat-toolbox versions --json | jq -r '.[] | select(test("^3"))' | tail -1)

echo "[INFO] Latest Hardhat 3.x version: $HH_VERSION"
echo "[INFO] Latest Hardhat Toolbox 3.x version: $TOOLBOX_VERSION"

# ------------------------
# 5. Install Hardhat 3.x and dependencies
# ------------------------
echo "[INFO] Installing Hardhat 3.x and Toolbox..."
npm install --save-dev hardhat@"$HH_VERSION" @nomicfoundation/hardhat-toolbox@"$TOOLBOX_VERSION"

# ------------------------
# 6. Update backend package.json scripts
# ------------------------
echo "[INFO] Updating backend package.json scripts for Hardhat 3.x..."
jq '.scripts.build="hardhat compile"' backend/package.json > backend/package_tmp.json && mv backend/package_tmp.json backend/package.json
jq '.scripts.test="hardhat test"' backend/package.json > backend/package_tmp.json && mv backend/package_tmp.json backend/package.json

# ------------------------
# 7. Create Hardhat 3.x config
# ------------------------
echo "[INFO] Creating new Hardhat 3.x config..."
cat > hardhat.config.js <<EOL
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    hardhat: {}
  }
};

export default config;
EOL

# ------------------------
# 8. Compile contracts
# ------------------------
echo "[INFO] Compiling contracts with Hardhat 3.x..."
npx hardhat compile

echo "=========================================="
echo "Hardhat 3.x upgrade workflow completed!"
echo "=========================================="

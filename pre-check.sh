#!/bin/bash
set -e

REQUIRED_NODE_MAJOR=16
REQUIRED_NODE_VERSION="16.20.0"  # Minimum recommended for Hardhat 2.x

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

# ----------------------------
# 1. Clear apt/dpkg locks
# ----------------------------
echo "[INFO] Checking for other apt/dpkg processes..."
sudo fuser -v /var/lib/dpkg/lock || true
sudo rm -f /var/lib/dpkg/lock
sudo dpkg --configure -a
echo "[INFO] apt/dpkg locks cleared. Continuing..."

# ----------------------------
# 2. Check Node.js
# ----------------------------
INSTALL_NODE=false
if command -v node &>/dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//')
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)
    echo "[INFO] Node.js version detected: $NODE_VERSION"

    if [ "$NODE_MAJOR" -lt "$REQUIRED_NODE_MAJOR" ]; then
        echo "[WARN] Node.js version is too old. Removing current version..."
        sudo apt remove -y nodejs
        sudo apt autoremove -y
        INSTALL_NODE=true
    fi
else
    echo "[WARN] Node.js not found. Will install required version."
    INSTALL_NODE=true
fi

if [ "$INSTALL_NODE" = true ]; then
    echo "[INFO] Installing Node.js $REQUIRED_NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
fi

echo "[INFO] Node.js version now: $(node -v)"
echo "[INFO] npm version: $(npm -v)"

# ----------------------------
# 3. Check npm
# ----------------------------
if ! command -v npm &>/dev/null; then
    echo "[INFO] npm not found. Installing..."
    sudo apt install -y npm
else
    echo "[OK] npm detected: $(npm -v)"
fi

# ----------------------------
# 4. Check npx
# ----------------------------
if ! command -v npx &>/dev/null; then
    echo "[INFO] npx not found. Installing..."
    sudo npm install -g npx
else
    echo "[OK] npx detected: $(npx -v)"
fi

# ----------------------------
# 5. Docker & Docker Compose
# ----------------------------
if command -v docker &>/dev/null; then
    echo "[OK] Docker version $(docker --version) detected"
else
    echo "[WARN] Docker not found. Please install Docker."
fi

if command -v docker-compose &>/dev/null || command -v docker compose &>/dev/null; then
    echo "[OK] Docker Compose detected"
else
    echo "[WARN] Docker Compose not found. Please install Docker Compose."
fi

# ----------------------------
# 6. Ensure Hardhat 2.x in backend
# ----------------------------
BACKEND_DIR="./backend"
cd "$BACKEND_DIR"

if [ -f package.json ]; then
    if grep -q '"hardhat"' package.json; then
        echo "[INFO] Hardhat found in package.json"

        # Force install compatible Hardhat 2.x and plugins
        echo "[INFO] Installing Hardhat 2.x stack..."
        npm install --save-dev "hardhat@^2.28.3" "@nomiclabs/hardhat-ethers@^2.2.3" ethers@^5.7.2
    else
        echo "[INFO] Hardhat not found. Installing Hardhat 2.x stack..."
        npm init -y
        npm install --save-dev "hardhat@^2.28.3" "@nomiclabs/hardhat-ethers@^2.2.3" ethers@^5.7.2
    fi
else
    echo "[WARN] backend/package.json not found. Creating and installing dependencies..."
    npm init -y
    npm install --save-dev "hardhat@^2.28.3" "@nomiclabs/hardhat-ethers@^2.2.3" ethers@^5.7.2
fi

# Ensure hardhat.config.js exists
if [ ! -f hardhat.config.js ]; then
    cat <<EOL > hardhat.config.js
/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
};
EOL
    echo "[INFO] Created hardhat.config.js for Hardhat 2.x"
fi

cd - >/dev/null

echo "=========================================="
echo "Host environment verification complete!"
echo "=========================================="

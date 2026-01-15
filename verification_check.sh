#!/bin/bash
set -e

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

# ------------------------
# 1. Node.js v20
# ------------------------
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node -v)
    if [[ "$NODE_VERSION" =~ ^v20 ]]; then
        echo "[OK] Node.js $NODE_VERSION detected"
    else
        echo "[WARNING] Node.js $NODE_VERSION detected, but v20.x is required."
        INSTALL_NODE=true
    fi
else
    echo "[WARNING] Node.js is NOT installed."
    INSTALL_NODE=true
fi

if [ "$INSTALL_NODE" = true ]; then
    echo "[INFO] Installing Node.js v20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "[OK] Node.js $(node -v) installed"
fi

# ------------------------
# 2. npm
# ------------------------
if command -v npm >/dev/null 2>&1; then
    echo "[OK] npm $(npm -v) detected"
else
    echo "[INFO] npm not found, installing via Node.js..."
    sudo apt-get install -y npm
    echo "[OK] npm $(npm -v) installed"
fi

# ------------------------
# 3. npx
# ------------------------
if command -v npx >/dev/null 2>&1; then
    echo "[OK] npx $(npx -v) detected"
else
    echo "[INFO] npx not found, installing via npm..."
    sudo npm install -g npx
    echo "[OK] npx $(npx -v) installed"
fi

# ------------------------
# 4. Hardhat (global install optional)
# ------------------------
if ! command -v npx >/dev/null 2>&1 || ! grep -q "hardhat" backend/package.json; then
    echo "[INFO] Installing Hardhat locally in backend..."
    cd backend
    npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox ethers
    cd ..
    echo "[OK] Hardhat installed in backend"
else
    echo "[OK] Hardhat already listed in backend/package.json"
fi

# ------------------------
# 5. Docker
# ------------------------
if command -v docker >/dev/null 2>&1; then
    echo "[OK] Docker $(docker --version) detected"
else
    echo "[ERROR] Docker is not installed! Please install Docker manually: https://docs.docker.com/engine/install/ubuntu/"
fi

if command -v docker-compose >/dev/null 2>&1 || docker compose version >/dev/null 2>&1; then
    echo "[OK] Docker Compose detected"
else
    echo "[ERROR] Docker Compose is not installed! Install via https://docs.docker.com/compose/install/"
fi

echo "=========================================="
echo "Host environment remediation complete!"
echo "You should now be able to run ./pre-start.sh"
echo "=========================================="

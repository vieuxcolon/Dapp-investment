#!/bin/bash
set -e

echo "=========================================="
echo "Verifying host environment for pre-start.sh"
echo "=========================================="

# ------------------------------
# 1. Node.js
# ------------------------------
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node -v)
    echo "[OK] Node.js is installed: $NODE_VERSION"
else
    echo "[ERROR] Node.js is NOT installed."
    echo "        Please install Node.js v24.x from https://nodejs.org/"
    exit 1
fi

# ------------------------------
# 2. npm
# ------------------------------
if command -v npm >/dev/null 2>&1; then
    NPM_VERSION=$(npm -v)
    echo "[OK] npm is installed: $NPM_VERSION"
else
    echo "[ERROR] npm is NOT installed."
    echo "        Please install npm (comes with Node.js)."
    exit 1
fi

# ------------------------------
# 3. npx
# ------------------------------
if command -v npx >/dev/null 2>&1; then
    NPX_VERSION=$(npx -v)
    echo "[OK] npx is installed: $NPX_VERSION"
else
    echo "[ERROR] npx is NOT installed."
    echo "        npx comes with npm 5.2+."
    exit 1
fi

# ------------------------------
# 4. Hardhat CLI (optional, mostly via npx)
# ------------------------------
if npx hardhat --version >/dev/null 2>&1; then
    HARDHAT_VERSION=$(npx hardhat --version)
    echo "[OK] Hardhat CLI is available: $HARDHAT_VERSION"
else
    echo "[WARNING] Hardhat CLI not installed globally."
    echo "          You can still run via 'npx hardhat'."
fi

# ------------------------------
# 5. Git (optional)
# ------------------------------
if command -v git >/dev/null 2>&1; then
    GIT_VERSION=$(git --version)
    echo "[OK] Git is installed: $GIT_VERSION"
else
    echo "[WARNING] Git is not installed."
    echo "          Required only if cloning repos or using git commands."
fi

echo "=========================================="
echo "Host environment verification complete!"
echo "If all [OK] checks pass, pre-start.sh should run successfully."
echo "=========================================="

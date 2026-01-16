#!/bin/bash
# pre-check.sh
# ================================
# Verify host environment for Dapp Investment project
# Ensures Node, npm, Hardhat, Docker, and dependencies are correct
# ================================

set -e

echo "=========================================="
echo "Pre-check script for Dapp Investment Dapp"
echo "=========================================="

# -------------------------
# 1. Check Node.js version
# -------------------------
REQUIRED_NODE="20"
NODE_VERSION=$(node -v | cut -d. -f1 | tr -d 'v')

if [ "$NODE_VERSION" -lt "$REQUIRED_NODE" ]; then
  echo "[ERROR] Node.js version $REQUIRED_NODE.x or higher required. Found $(node -v)"
  exit 1
else
  echo "[OK] Node.js version $(node -v)"
fi

# -------------------------
# 2. Check npm version
# -------------------------
REQUIRED_NPM="9"
NPM_VERSION=$(npm -v | cut -d. -f1)

if [ "$NPM_VERSION" -lt "$REQUIRED_NPM" ]; then
  echo "[ERROR] npm version $REQUIRED_NPM.x or higher required. Found $(npm -v)"
  exit 1
else
  echo "[OK] npm version $(npm -v)"
fi

# -------------------------
# 3. Check Hardhat
# -------------------------
if command -v npx >/dev/null 2>&1; then
  HH_VERSION=$(npx hardhat --version 2>/dev/null || echo "not found")
  if [[ "$HH_VERSION" == "not found" ]]; then
    echo "[WARN] Hardhat not installed. Installing Hardhat 3.x..."
    npm install --save-dev hardhat@3.1.4 @nomicfoundation/hardhat-toolbox@3.0.0 \
      @nomicfoundation/hardhat-ethers@3.1.3 @nomicfoundation/hardhat-chai-matchers@2.1.2 \
      chai@^4.2.0 --legacy-peer-deps
    echo "[OK] Hardhat installed successfully"
  else
    echo "[OK] Hardhat version $HH_VERSION"
  fi
else
  echo "[ERROR] npx not found. Ensure npm is installed correctly."
  exit 1
fi

# -------------------------
# 4. Check Docker
# -------------------------
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker not installed. Please install Docker."
  exit 1
else
  DOCKER_VER=$(docker --version)
  echo "[OK] Docker found: $DOCKER_VER"
fi

# -------------------------
# 5. Check Docker Compose
# -------------------------
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "[ERROR] docker-compose not installed. Please install docker-compose."
  exit 1
else
  DC_VER=$(docker-compose --version)
  echo "[OK] Docker Compose found: $DC_VER"
fi

# -------------------------
# 6. Check .env file
# -------------------------
if [ ! -f ".env" ]; then
  echo "[WARN] .env file not found. Creating a template .env"
  cp .env.example .env
else
  echo "[OK] .env file found"
fi

# -------------------------
# 7. Check frontend & backend dependencies
# -------------------------
for DIR in backend frontend; do
  echo "Checking dependencies in $DIR..."
  if [ -f "$DIR/package.json" ]; then
    (cd "$DIR" && npm install --legacy-peer-deps)
    echo "[OK] Dependencies installed in $DIR"
  else
    echo "[WARN] $DIR/package.json not found"
  fi
done

# -------------------------
# 8. Summary
# -------------------------
echo "=========================================="
echo "Pre-check completed successfully!"
echo "You can now run ./update-repo.sh, ./pre-start.sh or ./start.sh safely."
echo "=========================================="

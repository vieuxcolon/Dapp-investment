#!/bin/bash
set -e

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

# ----------------------------
# Helper functions
# ----------------------------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

version_ge() {
  # Compare two semantic versions: $1 >= $2
  [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# ----------------------------
# 1. Clear apt/dpkg locks
# ----------------------------
echo "[INFO] Checking for other apt/dpkg processes..."
sudo fuser -vki /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock >/dev/null 2>&1 || true
sudo dpkg --configure -a >/dev/null 2>&1 || true
echo "[INFO] apt/dpkg locks cleared. Continuing..."

# ----------------------------
# 2. Node.js v20.x
# ----------------------------
REQUIRED_NODE_VERSION="20"

if command_exists node; then
  NODE_VERSION=$(node -v | sed 's/v//')
  if version_ge "$NODE_VERSION" "$REQUIRED_NODE_VERSION"; then
    echo "[OK] Node.js v$NODE_VERSION detected"
  else
    echo "[WARNING] Node.js v$NODE_VERSION detected, but v$REQUIRED_NODE_VERSION.x is required"
    INSTALL_NODE=true
  fi
else
  echo "[WARNING] Node.js not detected"
  INSTALL_NODE=true
fi

if [ "$INSTALL_NODE" = true ]; then
  echo "[INFO] Installing Node.js v$REQUIRED_NODE_VERSION..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# Verify npm and npx
NPM_VERSION=$(npm -v || echo "0")
NPX_VERSION=$(npx -v || echo "0")
echo "[OK] npm $NPM_VERSION detected"
echo "[OK] npx $NPX_VERSION detected"

# ----------------------------
# 3. Hardhat in backend
# ----------------------------
BACKEND_DIR="./backend"
cd "$BACKEND_DIR"
if grep -q '"hardhat":' package.json; then
  echo "[OK] Hardhat already listed in backend/package.json"
else
  echo "[INFO] Installing Hardhat..."
  npm install --save-dev hardhat@3.3.0
fi
cd - >/dev/null

# ----------------------------
# 4. Docker
# ----------------------------
if command_exists docker; then
  DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
  echo "[OK] Docker Docker version $DOCKER_VERSION detected"
else
  echo "[INFO] Installing Docker..."
  sudo apt-get update
  sudo apt-get install -y docker.io
fi

# ----------------------------
# 5. Docker Compose (v2.28.4+)
# ----------------------------
REQUIRED_COMPOSE_VERSION="2.28.4"

if command_exists docker-compose; then
  COMPOSE_VERSION=$(docker-compose version --short)
  if version_ge "$COMPOSE_VERSION" "$REQUIRED_COMPOSE_VERSION"; then
    echo "[OK] Docker Compose v$COMPOSE_VERSION detected"
  else
    echo "[INFO] Updating Docker Compose..."
    sudo apt-get remove -y docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
else
  echo "[INFO] Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.39.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

echo "=========================================="
echo "Host environment remediation complete!"
echo "You should now be able to run ./pre-start.sh and ./start.sh"
echo "=========================================="

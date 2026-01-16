# frontend.Dockerfile
FROM node:24-bullseye

WORKDIR /app/frontend

# Copy only package files first for caching
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Install dotenv-cli globally to load .env at runtime
RUN npm install -g dotenv-cli

# Copy the rest of the frontend code
COPY frontend/ ./

# Optional: Pre-build frontend (React)
RUN npm run build || echo "[WARN] Build step failed, continue for development mode"

# Expose React default port
EXPOSE 3000

# Start frontend using dotenv to load environment variables
CMD ["dotenv", "-e", ".env", "--", "npm", "start"]

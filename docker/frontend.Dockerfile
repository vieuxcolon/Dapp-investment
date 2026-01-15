# frontend.Dockerfile
FROM node:24-bullseye

WORKDIR /app/frontend

# Copy only package files first for caching
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Install dotenv-cli to load .env at runtime
RUN npm install -g dotenv-cli

# Copy the rest of the frontend code
COPY frontend/ ./

# Expose React default port
EXPOSE 3000

# Run frontend and load environment variables at runtime
CMD ["dotenv", "-e", ".env", "--", "npm", "start"]

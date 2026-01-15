# frontend.Dockerfile
FROM node:20-bullseye

WORKDIR /app/frontend

# Copy package.json first for caching
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy frontend source code
COPY frontend/ ./

EXPOSE 3000

# Start React frontend
CMD ["npm", "start"]

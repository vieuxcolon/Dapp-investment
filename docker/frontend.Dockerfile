FROM node:20-bullseye

WORKDIR /app/frontend

# Copy package files first
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy frontend source code
COPY frontend/ ./

EXPOSE 3000

CMD ["npm", "start"]

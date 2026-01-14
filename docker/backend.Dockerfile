FROM node:24-bullseye

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install

COPY backend/ ./

EXPOSE 8545
CMD ["npx", "hardhat", "node"]

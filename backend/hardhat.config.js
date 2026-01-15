import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

export default {
  solidity: "0.8.20",
  networks: {
    localhost: {
      url: process.env.LOCAL_RPC_URL || "http://127.0.0.1:8545",
      accounts: process.env.PRIVATE_KEY
        ? [process.env.PRIVATE_KEY]
        : []
    }
  }
};

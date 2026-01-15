import { ethers } from "ethers";
import DAOTokenABI from "../contracts/DAOToken.json";
import GovernanceABI from "../contracts/Governance.json";
import ProposalExecutorABI from "../contracts/ProposalExecutor.json";
import TreasuryABI from "../contracts/Treasury.json";

// Read environment variables
const {
  REACT_APP_DAOTOKEN_ADDRESS,
  REACT_APP_GOVERNANCE_ADDRESS,
  REACT_APP_TREASURY_ADDRESS,
  REACT_APP_PROPOSALEXECUTOR_ADDRESS,
  REACT_APP_RPC_URL,
} = process.env;

// Validate addresses (lazy-safe)
function validateEnv() {
  if (
    !REACT_APP_DAOTOKEN_ADDRESS ||
    !REACT_APP_GOVERNANCE_ADDRESS ||
    !REACT_APP_TREASURY_ADDRESS ||
    !REACT_APP_PROPOSALEXECUTOR_ADDRESS
  ) {
    throw new Error(
      "Missing REACT_APP_* contract addresses. " +
      "Run `npx hardhat run scripts/deploy.js --network localhost`."
    );
  }
}

// Provider factory
function getProvider() {
  if (window.ethereum) {
    return new ethers.BrowserProvider(window.ethereum);
  }
  if (!REACT_APP_RPC_URL) {
    throw new Error("No RPC URL available");
  }
  return new ethers.JsonRpcProvider(REACT_APP_RPC_URL);
}

// Async contract loader (CORRECT for ethers v6)
export async function getContracts() {
  validateEnv();

  const provider = getProvider();

  // Request MetaMask access if available
  if (window.ethereum) {
    await provider.send("eth_requestAccounts", []);
  }

  const signer = await provider.getSigner();

  return {
    daoToken: new ethers.Contract(
      REACT_APP_DAOTOKEN_ADDRESS,
      DAOTokenABI,
      signer
    ),
    governance: new ethers.Contract(
      REACT_APP_GOVERNANCE_ADDRESS,
      GovernanceABI,
      signer
    ),
    executor: new ethers.Contract(
      REACT_APP_PROPOSALEXECUTOR_ADDRESS,
      ProposalExecutorABI,
      signer
    ),
    treasury: new ethers.Contract(
      REACT_APP_TREASURY_ADDRESS,
      TreasuryABI,
      signer
    ),
  };
}

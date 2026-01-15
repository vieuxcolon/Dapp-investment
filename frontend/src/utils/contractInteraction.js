import { ethers } from "ethers";
import DAOTokenABI from "../contracts/DAOToken.json";
import GovernanceABI from "../contracts/Governance.json";
import ProposalExecutorABI from "../contracts/ProposalExecutor.json";
import TreasuryABI from "../contracts/Treasury.json";

// Get addresses from environment variables
const {
  REACT_APP_DAOTOKEN_ADDRESS,
  REACT_APP_GOVERNANCE_ADDRESS,
  REACT_APP_TREASURY_ADDRESS,
  REACT_APP_PROPOSALEXECUTOR_ADDRESS,
  REACT_APP_RPC_URL,
} = process.env;

// Check that all addresses are defined
if (
  !REACT_APP_DAOTOKEN_ADDRESS ||
  !REACT_APP_GOVERNANCE_ADDRESS ||
  !REACT_APP_TREASURY_ADDRESS ||
  !REACT_APP_PROPOSALEXECUTOR_ADDRESS
) {
  throw new Error(
    " One or more REACT_APP_* contract addresses are missing in frontend/.env. " +
    "Please run `npx hardhat run scripts/deploy.js` to deploy contracts and update .env"
  );
}

// Use injected provider (MetaMask) or fallback to RPC URL
const provider = window.ethereum
  ? new ethers.BrowserProvider(window.ethereum)
  : new ethers.JsonRpcProvider(REACT_APP_RPC_URL);

const signer = provider.getSigner();

// Contract instances
export const daoToken = new ethers.Contract(REACT_APP_DAOTOKEN_ADDRESS, DAOTokenABI, signer);
export const governance = new ethers.Contract(REACT_APP_GOVERNANCE_ADDRESS, GovernanceABI, signer);
export const executor = new ethers.Contract(REACT_APP_PROPOSALEXECUTOR_ADDRESS, ProposalExecutorABI, signer);
export const treasury = new ethers.Contract(REACT_APP_TREASURY_ADDRESS, TreasuryABI, signer);

console.log(" Contract instances initialized successfully.");

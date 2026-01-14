import { ethers } from "ethers";
import DAOTokenABI from "../contracts/DAOToken.json";
import GovernanceABI from "../contracts/Governance.json";
import ProposalExecutorABI from "../contracts/ProposalExecutor.json";
import TreasuryABI from "../contracts/Treasury.json";
import addresses from "../contracts-address.json";

// Create provider and signer
const provider = new ethers.BrowserProvider(window.ethereum);
const signer = provider.getSigner();

// Contract instances
export const daoToken = new ethers.Contract(addresses.DAOToken, DAOTokenABI, signer);
export const governance = new ethers.Contract(addresses.Governance, GovernanceABI, signer);
export const executor = new ethers.Contract(addresses.ProposalExecutor, ProposalExecutorABI, signer);
export const treasury = new ethers.Contract(addresses.Treasury, TreasuryABI, signer);

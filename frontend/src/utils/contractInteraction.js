import { ethers } from "ethers";
import DAOTokenABI from "../contracts/DAOToken.json";
import GovernanceABI from "../contracts/Governance.json";
import ProposalExecutorABI from "../contracts/ProposalExecutor.json";
import TreasuryABI from "../contracts/Treasury.json";

// Use environment variables instead of static addresses
const DAOTokenAddress = process.env.REACT_APP_DAOTOKEN_ADDRESS;
const GovernanceAddress = process.env.REACT_APP_GOVERNANCE_ADDRESS;
const ProposalExecutorAddress = process.env.REACT_APP_PROPOSALEXECUTOR_ADDRESS;
const TreasuryAddress = process.env.REACT_APP_TREASURY_ADDRESS;

// Create provider and signer
const provider = new ethers.BrowserProvider(window.ethereum);
const signer = provider.getSigner();

// Contract instances
export const daoToken = new ethers.Contract(DAOTokenAddress, DAOTokenABI, signer);
export const governance = new ethers.Contract(GovernanceAddress, GovernanceABI, signer);
export const executor = new ethers.Contract(ProposalExecutorAddress, ProposalExecutorABI, signer);
export const treasury = new ethers.Contract(TreasuryAddress, TreasuryABI, signer);

import { ethers } from "ethers";
import contractAddresses from "../contracts-address.json";
import DAOTokenABI from "../contracts/DAOToken.json";
import GovernanceABI from "../contracts/Governance.json";

export const getDAOTokenContract = (provider) => {
  return new ethers.Contract(contractAddresses.DAOToken, DAOTokenABI, provider);
};

export const getGovernanceContract = (provider) => {
  return new ethers.Contract(contractAddresses.Governance, GovernanceABI, provider);
};

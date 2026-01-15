import fs from "fs";
import path from "path";
import { ethers } from "hardhat";

async function main() {
  //  Deploy contracts
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const DAOToken = await ethers.deployContract("DAOToken");
  await DAOToken.waitForDeployment();

  const Governance = await ethers.deployContract("Governance", [DAOToken.target]);
  await Governance.waitForDeployment();

  const Treasury = await ethers.deployContract("Treasury", [DAOToken.target, Governance.target]);
  await Treasury.waitForDeployment();

  const ProposalExecutor = await ethers.deployContract("ProposalExecutor", [Governance.target, Treasury.target]);
  await ProposalExecutor.waitForDeployment();

  console.log("Contracts deployed:");
  console.log("DAOToken:", DAOToken.target);
  console.log("Governance:", Governance.target);
  console.log("Treasury:", Treasury.target);
  console.log("ProposalExecutor:", ProposalExecutor.target);

  //  Update frontend .env file
  const envPath = path.resolve(__dirname, "../../frontend/.env");
  const envContent = `
REACT_APP_RPC_URL=http://localhost:8545
REACT_APP_DAOTOKEN_ADDRESS=${DAOToken.target}
REACT_APP_GOVERNANCE_ADDRESS=${Governance.target}
REACT_APP_TREASURY_ADDRESS=${Treasury.target}
REACT_APP_PROPOSALEXECUTOR_ADDRESS=${ProposalExecutor.target}
  `.trim();

  fs.writeFileSync(envPath, envContent, "utf-8");
  console.log(" Frontend .env updated successfully!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

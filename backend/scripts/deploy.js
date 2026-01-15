import fs from "fs";
import path from "path";
import { ethers } from "hardhat";

async function main() {
  // ------------------------------
  // 1. Get deployer account
  // ------------------------------
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // ------------------------------
  // 2. Deploy contracts
  // ------------------------------

  // DAOToken constructor: name, symbol, initialSupply
  const DAOToken = await ethers.deployContract("DAOToken", ["Investment DAO Token", "IDT", 1000000]);
  await DAOToken.waitForDeployment();

  const Governance = await ethers.deployContract("Governance", [DAOToken.target]);
  await Governance.waitForDeployment();

  const Treasury = await ethers.deployContract("Treasury", [DAOToken.target, Governance.target]);
  await Treasury.waitForDeployment();

  const ProposalExecutor = await ethers.deployContract("ProposalExecutor", [Governance.target, Treasury.target]);
  await ProposalExecutor.waitForDeployment();

  console.log("\n Contracts deployed successfully:");
  console.log("DAOToken:", DAOToken.target);
  console.log("Governance:", Governance.target);
  console.log("Treasury:", Treasury.target);
  console.log("ProposalExecutor:", ProposalExecutor.target);

  // ------------------------------
  // 3. Update .env files
  // ------------------------------
  const filesToUpdate = [
    path.resolve(__dirname, "../../frontend/.env"),
    path.resolve(__dirname, "../../backend/.env"),
  ];

  filesToUpdate.forEach((envPath) => {
    try {
      let envLines = fs.existsSync(envPath) ? fs.readFileSync(envPath, "utf-8").split("\n") : [];

      const updatedLines = envLines.map((line) => {
        if (line.startsWith("REACT_APP_DAOTOKEN_ADDRESS") || line.startsWith("DAOTOKEN_ADDRESS"))
          return `DAOTOKEN_ADDRESS=${DAOToken.target}`;
        if (line.startsWith("REACT_APP_GOVERNANCE_ADDRESS") || line.startsWith("GOVERNANCE_ADDRESS"))
          return `GOVERNANCE_ADDRESS=${Governance.target}`;
        if (line.startsWith("REACT_APP_TREASURY_ADDRESS") || line.startsWith("TREASURY_ADDRESS"))
          return `TREASURY_ADDRESS=${Treasury.target}`;
        if (line.startsWith("REACT_APP_PROPOSALEXECUTOR_ADDRESS") || line.startsWith("PROPOSALEXECUTOR_ADDRESS"))
          return `PROPOSALEXECUTOR_ADDRESS=${ProposalExecutor.target}`;
        return line;
      });

      fs.writeFileSync(envPath, updatedLines.join("\n"), "utf-8");
      console.log(` Updated ${envPath}`);
    } catch (err) {
      console.error(` Error updating ${envPath}:`, err);
    }
  });

  console.log("\nAll .env files updated with deployed contract addresses!");
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});


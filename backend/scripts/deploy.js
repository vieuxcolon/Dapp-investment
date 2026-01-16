import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { ethers } from "hardhat";

// Fix __dirname for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Utility to update .env file
function updateEnvFile(envPath, addresses) {
  let envLines = fs.existsSync(envPath) ? fs.readFileSync(envPath, "utf-8").split("\n") : [];

  const updatedLines = envLines.map((line) => {
    if (line.startsWith("DAOTOKEN_ADDRESS") || line.startsWith("REACT_APP_DAOTOKEN_ADDRESS"))
      return `DAOTOKEN_ADDRESS=${addresses.DAOTOKEN}`;
    if (line.startsWith("GOVERNANCE_ADDRESS") || line.startsWith("REACT_APP_GOVERNANCE_ADDRESS"))
      return `GOVERNANCE_ADDRESS=${addresses.GOVERNANCE}`;
    if (line.startsWith("TREASURY_ADDRESS") || line.startsWith("REACT_APP_TREASURY_ADDRESS"))
      return `TREASURY_ADDRESS=${addresses.TREASURY}`;
    if (line.startsWith("PROPOSALEXECUTOR_ADDRESS") || line.startsWith("REACT_APP_PROPOSALEXECUTOR_ADDRESS"))
      return `PROPOSALEXECUTOR_ADDRESS=${addresses.PROPOSALEXECUTOR}`;
    return line;
  });

  // Add missing variables if they were not present
  const keys = ["DAOTOKEN_ADDRESS", "GOVERNANCE_ADDRESS", "TREASURY_ADDRESS", "PROPOSALEXECUTOR_ADDRESS"];
  keys.forEach((key) => {
    if (!updatedLines.some((line) => line.startsWith(key))) {
      updatedLines.push(`${key}=${addresses[key]}`);
    }
  });

  fs.writeFileSync(envPath, updatedLines.join("\n"), "utf-8");
  console.log(`✅ Updated ${envPath}`);
}

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // ------------------------------ Deploy contracts ------------------------------
  const DAOToken = await ethers.deployContract("DAOToken", ["Investment DAO Token", "IDT", 1000000]);
  await DAOToken.waitForDeployment();

  const Governance = await ethers.deployContract("Governance", [DAOToken.target]);
  await Governance.waitForDeployment();

  const Treasury = await ethers.deployContract("Treasury", [DAOToken.target, Governance.target]);
  await Treasury.waitForDeployment();

  const ProposalExecutor = await ethers.deployContract("ProposalExecutor", [Governance.target, Treasury.target]);
  await ProposalExecutor.waitForDeployment();

  console.log("\n✅ Contracts deployed successfully:");
  console.log("DAOToken:", DAOToken.target);
  console.log("Governance:", Governance.target);
  console.log("Treasury:", Treasury.target);
  console.log("ProposalExecutor:", ProposalExecutor.target);

  const addresses = {
    DAOTOKEN: DAOToken.target,
    GOVERNANCE: Governance.target,
    TREASURY: Treasury.target,
    PROPOSALEXECUTOR: ProposalExecutor.target,
  };

  // ------------------------------ Update .env files ------------------------------
  const envPaths = [
    path.resolve(__dirname, "../../frontend/.env"),
    path.resolve(__dirname, "../../backend/.env"),
  ];

  envPaths.forEach((envPath) => updateEnvFile(envPath, addresses));

  // ------------------------------ Write contracts-address.json ------------------------------
  const jsonPath = path.resolve(__dirname, "../../frontend/contracts-address.json");
  fs.writeFileSync(jsonPath, JSON.stringify(addresses, null, 2));
  console.log(`✅ Written contract addresses to ${jsonPath}`);
}

main().catch((err) => {
  console.error("❌ Deployment failed:", err);
  process.exit(1);
});

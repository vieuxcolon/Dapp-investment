
import fs from "fs";
import hre from "hardhat";

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const DAOToken = await hre.ethers.deployContract("DAOToken");
  await DAOToken.waitForDeployment();

  const Treasury = await hre.ethers.deployContract("Treasury");
  await Treasury.waitForDeployment();

  const Governance = await hre.ethers.deployContract("Governance", [DAOToken.target, Treasury.target]);
  await Governance.waitForDeployment();

  const ProposalExecutor = await hre.ethers.deployContract("ProposalExecutor", [Governance.target, Treasury.target]);
  await ProposalExecutor.waitForDeployment();

  // Write addresses to JSON
  const addresses = {
    DAOToken: DAOToken.target,
    Governance: Governance.target,
    Treasury: Treasury.target,
    ProposalExecutor: ProposalExecutor.target
  };

  fs.writeFileSync(
    "./frontend/src/contracts-address.json",
    JSON.stringify(addresses, null, 2)
  );

  console.log("Contracts deployed and addresses saved to frontend/src/contracts-address.json");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

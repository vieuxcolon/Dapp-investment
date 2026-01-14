async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const DAOToken = await ethers.getContractFactory("DAOToken");
  const daoToken = await DAOToken.deploy();
  await daoToken.deployed();
  console.log("DAOToken deployed to:", daoToken.address);

  const Treasury = await ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy();
  await treasury.deployed();
  console.log("Treasury deployed to:", treasury.address);

  const Governance = await ethers.getContractFactory("Governance");
  const governance = await Governance.deploy(daoToken.address, treasury.address);
  await governance.deployed();
  console.log("Governance deployed to:", governance.address);

  const ProposalExecutor = await ethers.getContractFactory("ProposalExecutor");
  const executor = await ProposalExecutor.deploy(governance.address, treasury.address);
  await executor.deployed();
  console.log("ProposalExecutor deployed to:", executor.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

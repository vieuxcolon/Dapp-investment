import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { getContracts } from "../utils/contractInteraction";

export default function Dashboard() {
  const [balance, setBalance] = useState("0");
  const [tokenBalance, setTokenBalance] = useState("0");
  const [proposalCount, setProposalCount] = useState(0);

  useEffect(() => {
    async function loadData() {
      const { daoToken, governance, treasury } = await getContracts();
      const signer = await daoToken.runner;
      const address = await signer.getAddress();

      setTokenBalance(await daoToken.balanceOf(address));
      setBalance(await treasury.getBalance());
      setProposalCount(await governance.proposalCount());
    }

    loadData();
  }, []);

  return (
    <div>
      <h2>DAO Dashboard</h2>
      <p>Your Token Balance: {tokenBalance.toString()}</p>
      <p>Treasury Balance: {ethers.formatEther(balance)} ETH</p>
      <p>Total Proposals: {proposalCount.toString()}</p>
    </div>
  );
}

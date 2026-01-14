
import React, { useEffect, useState } from "react";
import { daoToken, governance, treasury } from "../utils/contractInteraction";

export default function Dashboard() {
  const [balance, setBalance] = useState(0);
  const [tokenBalance, setTokenBalance] = useState(0);
  const [proposalCount, setProposalCount] = useState(0);

  const loadData = async () => {
    const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
    setTokenBalance(await daoToken.balanceOf(accounts[0]));
    setBalance(await treasury.getBalance());
    setProposalCount(await governance.proposalCount());
  };

  useEffect(() => {
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

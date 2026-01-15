import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { getContracts } from "../utils/contractInteraction";

export default function TreasuryView() {
  const [balance, setBalance] = useState("0");

  useEffect(() => {
    async function loadBalance() {
      const { treasury } = await getContracts();
      setBalance(await treasury.getBalance());
    }
    loadBalance();
  }, []);

  return (
    <div>
      <h3>Treasury</h3>
      <p>Balance: {ethers.formatEther(balance)} ETH</p>
    </div>
  );
}

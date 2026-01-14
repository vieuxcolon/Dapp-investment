import React, { useEffect, useState } from "react";
import { treasury } from "../utils/contractInteraction";

export default function TreasuryView() {
  const [balance, setBalance] = useState(0);

  const loadBalance = async () => {
    setBalance(await treasury.getBalance());
  };

  useEffect(() => {
    loadBalance();
  }, []);

  return (
    <div>
      <h3>Treasury</h3>
      <p>Balance: {ethers.formatEther(balance)} ETH</p>
    </div>
  );
}

import React, { useState } from "react";
import { ethers } from "ethers";
import { getContracts } from "../utils/contractInteraction";

export default function SubmitProposal() {
  const [description, setDescription] = useState("");
  const [amount, setAmount] = useState("");
  const [type, setType] = useState("Startup");

  async function submit() {
    const { governance } = await getContracts();
    const proposalType = type === "Startup" ? 0 : 1;

    const tx = await governance.submitProposal(
      proposalType,
      description,
      ethers.parseEther(amount)
    );
    await tx.wait();

    alert("Proposal submitted!");
  }

  return (
    <div>
      <h3>Submit Proposal</h3>
      <select value={type} onChange={(e) => setType(e.target.value)}>
        <option value="Startup">Startup Funding</option>
        <option value="AssetTrade">Asset Trade</option>
      </select>
      <input value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Description" />
      <input value={amount} onChange={(e) => setAmount(e.target.value)} placeholder="Amount in ETH" />
      <button onClick={submit}>Submit Proposal</button>
    </div>
  );
}

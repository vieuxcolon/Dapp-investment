import React, { useState } from "react";
import { governance } from "../utils/contractInteraction";

export default function SubmitProposal() {
  const [description, setDescription] = useState("");
  const [amount, setAmount] = useState("");
  const [type, setType] = useState("Startup");

  const submit = async () => {
    const proposalType = type === "Startup" ? 0 : 1; // Enum mapping
    await governance.submitProposal(proposalType, description, ethers.parseEther(amount));
    alert("Proposal submitted!");
  };

  return (
    <div>
      <h3>Submit Proposal</h3>
      <select value={type} onChange={(e) => setType(e.target.value)}>
        <option value="Startup">Startup Funding</option>
        <option value="AssetTrade">Asset Trade</option>
      </select>
      <input placeholder="Description" value={description} onChange={(e) => setDescription(e.target.value)} />
      <input placeholder="Amount in ETH" value={amount} onChange={(e) => setAmount(e.target.value)} />
      <button onClick={submit}>Submit Proposal</button>
    </div>
  );
}

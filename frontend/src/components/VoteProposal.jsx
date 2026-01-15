import React, { useState } from "react";
import { getContracts } from "../utils/contractInteraction";

export default function VoteProposal() {
  const [proposalId, setProposalId] = useState("");
  const [support, setSupport] = useState(true);

  async function vote() {
    const { governance } = await getContracts();
    const tx = await governance.vote(proposalId, support);
    await tx.wait();
    alert("Vote submitted!");
  }

  return (
    <div>
      <h3>Vote on Proposal</h3>
      <input value={proposalId} onChange={(e) => setProposalId(e.target.value)} placeholder="Proposal ID" />
      <select value={support} onChange={(e) => setSupport(e.target.value === "true")}>
        <option value="true">Yes</option>
        <option value="false">No</option>
      </select>
      <button onClick={vote}>Vote</button>
    </div>
  );
}

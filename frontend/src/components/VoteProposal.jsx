import React, { useState } from "react";
import { governance } from "../utils/contractInteraction";

export default function VoteProposal() {
  const [proposalId, setProposalId] = useState("");
  const [support, setSupport] = useState(true);

  const vote = async () => {
    await governance.vote(proposalId, support);
    alert("Vote submitted!");
  };

  return (
    <div>
      <h3>Vote on Proposal</h3>
      <input placeholder="Proposal ID" value={proposalId} onChange={(e) => setProposalId(e.target.value)} />
      <select value={support} onChange={(e) => setSupport(e.target.value === "true")}>
        <option value="true">Yes</option>
        <option value="false">No</option>
      </select>
      <button onClick={vote}>Vote</button>
    </div>
  );
}


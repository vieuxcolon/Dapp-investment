import React, { useState } from "react";
import { getContracts } from "../utils/contractInteraction";

export default function ExecuteProposal() {
  const [proposalId, setProposalId] = useState("");
  const [recipient, setRecipient] = useState("");

  async function execute() {
    const { executor } = await getContracts();
    const tx = await executor.executeProposal(proposalId, recipient);
    await tx.wait();
    alert("Proposal executed!");
  }

  return (
    <div>
      <h3>Execute Proposal</h3>
      <input value={proposalId} onChange={(e) => setProposalId(e.target.value)} placeholder="Proposal ID" />
      <input value={recipient} onChange={(e) => setRecipient(e.target.value)} placeholder="Recipient Address" />
      <button onClick={execute}>Execute</button>
    </div>
  );
}


import React, { useState } from "react";
import { executor } from "../utils/contractInteraction";

export default function ExecuteProposal() {
  const [proposalId, setProposalId] = useState("");
  const [recipient, setRecipient] = useState("");

  const execute = async () => {
    await executor.executeProposal(proposalId, recipient);
    alert("Proposal executed!");
  };

  return (
    <div>
      <h3>Execute Proposal</h3>
      <input placeholder="Proposal ID" value={proposalId} onChange={(e) => setProposalId(e.target.value)} />
      <input placeholder="Recipient Address" value={recipient} onChange={(e) => setRecipient(e.target.value)} />
      <button onClick={execute}>Execute</button>
    </div>
  );
}

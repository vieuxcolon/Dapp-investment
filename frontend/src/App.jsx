import React from "react";
import Dashboard from "./components/Dashboard";
import SubmitProposal from "./components/SubmitProposal";
import VoteProposal from "./components/VoteProposal";
import ExecuteProposal from "./components/ExecuteProposal";
import TreasuryView from "./components/TreasuryView";

function App() {
  return (
    <div>
      <h1>Investment DAO DApp</h1>
      <Dashboard />
      <SubmitProposal />
      <VoteProposal />
      <ExecuteProposal />
      <TreasuryView />
    </div>
  );
}

export default App;

// ProposalExecutor.sol
pragma solidity ^0.8.20;

import "./Governance.sol";

contract ProposalExecutor {
    Governance public governance;

    constructor(address _governance) {
        governance = Governance(_governance);
    }

    function executeProposal(uint256 _proposalId) external {
        (
            uint256 id,
            string memory description,
            uint256 votesFor,
            uint256 votesAgainst,
            bool executed
        ) = governance.getProposal(_proposalId);

        require(!executed, "Proposal already executed");
        require(votesFor > votesAgainst, "Proposal not approved");

        // Execute the proposal logic here (e.g., treasury actions)
        // ...

        // Mark the proposal as executed in Governance
        governance.markExecuted(_proposalId);
    }
}


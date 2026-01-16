
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Governance.sol";

/// @title Proposal Executor
/// @notice Executes proposals created in the Governance contract
contract ProposalExecutor {
    Governance public governance;

    /// @notice Sets the governance contract
    /// @param _governance The address of the deployed Governance contract
    constructor(address _governance) {
        governance = Governance(_governance);
    }

    /// @notice Execute a proposal by ID
    /// @param _proposalId The ID of the proposal to execute
    function executeProposal(uint256 _proposalId) external {
        // Get a copy of the proposal in memory
        Governance.Proposal memory proposal = governance.getProposal(_proposalId);

        // Ensure the proposal is executable
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > 0, "Proposal has no votes");

        // TODO: Add your actual execution logic here
        // Example: call Treasury to transfer funds, trigger other actions, etc.
        // Example: treasury.transfer(proposal.recipient, proposal.amount);

        // Mark the proposal as executed in the Governance contract
        governance.markExecuted(_proposalId);
    }
}

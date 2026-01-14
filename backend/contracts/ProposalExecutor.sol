// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Governance.sol";
import "./Treasury.sol";

/// @title ProposalExecutor - Executes approved DAO proposals
contract ProposalExecutor {
    Governance public governance;
    Treasury public treasury;

    event StartupFunded(uint256 proposalId, address startup, uint256 amount);
    event AssetTraded(uint256 proposalId, string tradeDetails);

    constructor(address _governance, address _treasury) {
        governance = Governance(_governance);
        treasury = Treasury(_treasury);
    }

    /// @notice Execute a passed proposal
    function executeProposal(uint256 _proposalId, address payable _recipient) external {
        Governance.Proposal memory proposal = governance.proposals(_proposalId);
        require(proposal.state == Governance.ProposalState.Active, "Proposal not active");
        require(governance.proposalPassed(_proposalId), "Proposal did not pass");

        if (proposal.proposalType == Governance.ProposalType.Startup) {
            treasury.transferFunds(_recipient, proposal.amount);
            emit StartupFunded(_proposalId, _recipient, proposal.amount);
        } else if (proposal.proposalType == Governance.ProposalType.AssetTrade) {
            // Placeholder for trading logic
            emit AssetTraded(_proposalId, "Execute asset trade logic here");
        }

        governance.markExecuted(_proposalId);
    }
}

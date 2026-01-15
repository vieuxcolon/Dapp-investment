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

    constructor(Governance _governance, Treasury _treasury) {
        governance = _governance;
        treasury = _treasury;
    }

    function executeProposal(uint256 _proposalId, address payable _recipient) external {
        Governance.Proposal storage proposal = governance.proposals(_proposalId);
        require(proposal.state == Governance.ProposalState.Active, "Proposal not active");
        require(governance.proposalPassed(_proposalId), "Proposal did not pass");

        if (proposal.proposalType == Governance.ProposalType.Startup) {
            treasury.transferFunds(_recipient, proposal.amount);
            emit StartupFunded(_proposalId, _recipient, proposal.amount);
        } else if (proposal.proposalType == Governance.ProposalType.AssetTrade) {
            emit AssetTraded(_proposalId, "Execute asset trade logic here");
        }

        governance.markExecuted(_proposalId);
    }
}

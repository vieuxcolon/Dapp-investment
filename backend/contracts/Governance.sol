// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./DAOToken.sol";
import "./Treasury.sol";

/// @title Governance - Submit & Vote on DAO Proposals
contract Governance is Ownable {
    DAOToken public daoToken;
    Treasury public treasury;

    uint256 public proposalCount;

    enum ProposalType { Startup, AssetTrade }
    enum ProposalState { Pending, Active, Passed, Failed, Executed }

    struct Proposal {
        uint256 id;
        ProposalType proposalType;
        address proposer;
        string description;
        uint256 amount; // Funds requested or trade amount
        uint256 yesVotes;
        uint256 noVotes;
        ProposalState state;
        uint256 startTime;
        uint256 endTime;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, ProposalType proposalType, address proposer);
    event VoteCast(uint256 indexed id, address voter, bool support);
    event ProposalExecuted(uint256 indexed id);

    constructor(address _daoToken, address payable _treasury) {
        daoToken = DAOToken(_daoToken);
        treasury = Treasury(_treasury); // _treasury is now payable-compatible
    }

    /// @notice Submit a new proposal
    function submitProposal(
        ProposalType _type,
        string calldata _description,
        uint256 _amount
    ) external {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposalType: _type,
            proposer: msg.sender,
            description: _description,
            amount: _amount,
            yesVotes: 0,
            noVotes: 0,
            state: ProposalState.Active,
            startTime: block.timestamp,
            endTime: block.timestamp + 3 days // Voting period
        });
        emit ProposalCreated(proposalCount, _type, msg.sender);
    }

    /// @notice Vote on a proposal
    function vote(uint256 _proposalId, bool support) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp <= proposal.endTime, "Voting period ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        uint256 votingPower = daoToken.balanceOf(msg.sender);
        require(votingPower > 0, "No voting power");

        if (support) {
            proposal.yesVotes += votingPower;
        } else {
            proposal.noVotes += votingPower;
        }

        hasVoted[_proposalId][msg.sender] = true;
        emit VoteCast(_proposalId, msg.sender, support);
    }

    /// @notice Check if a proposal passed
    function proposalPassed(uint256 _proposalId) public view returns (bool) {
        Proposal storage proposal = proposals[_proposalId];
        return proposal.yesVotes > proposal.noVotes;
    }

    /// @notice Mark proposal as executed (actual execution happens in ProposalExecutor)
    function markExecuted(uint256 _proposalId) external onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        proposal.state = ProposalState.Executed;
        emit ProposalExecuted(_proposalId);
    }
}

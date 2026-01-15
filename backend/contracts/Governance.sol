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
        uint256 amount;
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

    constructor(DAOToken _daoToken, Treasury _treasury) {
        daoToken = _daoToken;
        treasury = _treasury;
    }

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
            endTime: block.timestamp + 3 days
        });
        emit ProposalCreated(proposalCount, _type, msg.sender);
    }

    function vote(uint256 _proposalId, bool support) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp <= proposal.endTime, "Voting period ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");
        uint256 votingPower = daoToken.balanceOf(msg.sender);
        require(votingPower > 0, "No voting power");

        if (support) proposal.yesVotes += votingPower;
        else proposal.noVotes += votingPower;

        hasVoted[_proposalId][msg.sender] = true;
        emit VoteCast(_proposalId, msg.sender, support);
    }

    function proposalPassed(uint256 _proposalId) public view returns (bool) {
        Proposal storage proposal = proposals[_proposalId];
        return proposal.yesVotes > proposal.noVotes;
    }

    function markExecuted(uint256 _proposalId) external onlyOwner {
        proposals[_proposalId].state = ProposalState.Executed;
        emit ProposalExecuted(_proposalId);
    }
}

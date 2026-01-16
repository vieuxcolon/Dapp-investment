// Governance.sol
pragma solidity ^0.8.20;

contract Governance {
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;

    // Getter
    function getProposal(uint256 _proposalId)
        external
        view
        returns (
            uint256 id,
            string memory description,
            uint256 votesFor,
            uint256 votesAgainst,
            bool executed
        )
    {
        Proposal storage p = proposals[_proposalId];
        return (p.id, p.description, p.votesFor, p.votesAgainst, p.executed);
    }

    // New function: mark executed
    function markExecuted(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(!p.executed, "Proposal already executed");
        p.executed = true;
    }

    // other functions: createProposal, vote, etc.
}

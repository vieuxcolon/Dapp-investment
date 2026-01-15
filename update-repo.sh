#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

# --- Step 1: Backup existing HH2.x files ---
BACKUP_DIR="backup_hh2_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

for f in contracts hardhat.config.js package.json package-lock.json; do
    if [ -e "$f" ]; then
        cp -r "$f" "$BACKUP_DIR/"
        echo "[INFO] Backed up $f to $BACKUP_DIR"
    else
        echo "[WARN] $f not found, skipping backup."
    fi
done

# --- Step 2: Clean node_modules and lock files ---
echo "[INFO] Cleaning backend node_modules and package-lock..."
rm -rf node_modules package-lock.json

# --- Step 3: Install Hardhat 3.x and compatible dependencies ---
echo "[INFO] Installing Hardhat 3.x and toolbox..."
npm install --save-dev hardhat@3.1.4 @nomicfoundation/hardhat-toolbox@3.0.0 @openzeppelin/contracts@5.0.0

# --- Step 4: Drop in updated contracts ---
echo "[INFO] Dropping in HH3.x–compatible contracts..."
mkdir -p contracts

cat > contracts/DAOToken.sol <<'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOToken is ERC20, Ownable {
    constructor() ERC20("Investment DAO Token", "IDT") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
EOF

cat > contracts/Treasury.sol <<'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {
    receive() external payable {}

    function transferFunds(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient treasury balance");
        to.transfer(amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
EOF

cat > contracts/Governance.sol <<'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./DAOToken.sol";
import "./Treasury.sol";

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

    function submitProposal(ProposalType _type, string calldata _description, uint256 _amount) external {
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
EOF

cat > contracts/ProposalExecutor.sol <<'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Governance.sol";
import "./Treasury.sol";

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
EOF

# --- Step 5: Generate Hardhat 3.x config ---
echo "[INFO] Generating new hardhat.config.js..."
cat > hardhat.config.js <<'EOF'
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    hardhat: {}
  }
};
EOF

# --- Step 6: Compile contracts ---
echo "[INFO] Compiling contracts..."
npx hardhat compile

echo "[INFO] Hardhat 3.x upgrade completed successfully!"


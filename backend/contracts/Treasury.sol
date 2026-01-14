// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Treasury - Holds DAO funds and executes transfers
contract Treasury is Ownable {
    mapping(address => uint256) public balances;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    /// @notice Receive ETH deposits
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Transfer funds to a target (e.g., startup or trade)
    function transferFunds(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient treasury balance");
        to.transfer(amount);
        emit Withdraw(to, amount);
    }

    /// @notice View treasury balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

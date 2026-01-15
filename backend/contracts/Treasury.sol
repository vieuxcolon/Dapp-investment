// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Treasury - Holds DAO funds and executes transfers
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

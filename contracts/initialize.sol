// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultLogic {
    uint256 public balance;   // slot 0
    address public owner;     // slot 1
    bool private initialized; // slot 2

    // Replaces the constructor
    function initialize(address _owner) external {
        require(!initialized, "Already initialized");
        owner = _owner;
        balance = 0;
        initialized = true;
    }

    function deposit(uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        balance += amount;
    }
}
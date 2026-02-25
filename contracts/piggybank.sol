// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PiggyBank {
    address public owner;
    uint256 public unlockTime;

    constructor(uint256 lockDays) payable {
        owner      = msg.sender;
        unlockTime = block.timestamp + (lockDays * 1 minutes); // ← set the future unlock time
    }

    function deposit() external payable {
        require(msg.sender == owner, "Not your piggy bank");
    }

    function withdraw() external {
        require(msg.sender == owner, "Not your piggy bank");
        require(block.timestamp >= unlockTime, "Still locked"); // ← the key check

        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Payment failed!");
    }

    function timeRemaining() external view returns (uint256) {
        if (block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp; // seconds remaining
    }
}
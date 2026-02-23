// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DepositTracker {
    mapping(address => uint) public deposits;

    function deposit() external payable {
        require(msg.value > 0, "Must send some Ether");
        deposits[msg.sender] += msg.value;
    }

    function getMyDeposit() external view returns (uint) {
        return deposits[msg.sender];
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}

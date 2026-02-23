// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OwnerWithdraw {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }
    mapping (address=>uint) public deposits;
     function deposit() external payable {
        require(msg.value > 0, "Must send some Ether");
        deposits[msg.sender] += msg.value;
    }
    function withdraw(uint _amount) external {
        require(owner==msg.sender, "Only owner can withdraw");
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Withdraw failed");
    }
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
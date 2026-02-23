// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract reentancy{
    bool private locked;
    mapping (address=>uint) balances;

modifier nonReentrant() {
    require(!locked, "Reentrant call");
    locked = true;
    _;
    locked = false;
}

function deposit() public payable {
    balances[msg.sender] += msg.value;
} 

function withdraw(uint amount) public nonReentrant {
   require(balances[msg.sender] >= amount);
    
    // 1. Send ETH first (calls attacker's fallback function)
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success);
    
    // 2. Update state AFTER — too late!
    balances[msg.sender] -= amount;
}

}
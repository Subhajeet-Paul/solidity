// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

contract Owner {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Define the modifier
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert ("Not the owner!");
        }
        _; // Placeholder for the function body
    }

    // Apply the modifier to a function
    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    // A function with a modifier that takes an argument
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    function setNewOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }
}
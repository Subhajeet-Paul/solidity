// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheckBalance {
    // Accepts plain Ether transfers
    constructor() payable {}
    receive() external payable {

    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
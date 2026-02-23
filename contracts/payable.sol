// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TypeConversion {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function convertToPayable(address _addr) public pure returns (address payable) {
        return payable(_addr);
    }
}
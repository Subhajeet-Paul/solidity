// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomUnit {
    function random() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender
        )));
    }

    // Random number in a range [0, max)
    function randomInRange(uint256 max) public view returns (uint256) {
        return random() % max;
    }
}
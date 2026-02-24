// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CommitReveal {
    mapping(address => bytes32) public commits;

    // Phase 1: submit hash of (secret + your address)
    function commit(bytes32 hash) external {
        commits[msg.sender] = hash;
    }

    // Phase 2: reveal later — front-running now useless
    function reveal(string memory secret) external view  {
        bytes32 expected = keccak256(abi.encodePacked(secret, msg.sender));
        require(commits[msg.sender] == expected, "Hash mismatch");
        // process reward...
    }
}
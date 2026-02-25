// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtectedPuzzle {
    bytes32 public hashedAnswer;
    mapping(address => bytes32) public commits;
    mapping(address => uint256) public commitBlock;

    constructor(bytes32 _hashedAnswer) payable {
        hashedAnswer = _hashedAnswer;
    }

    // Phase 1: Submit a hidden commitment (hash of answer + secret)
    // Nobody can see your real answer yet
    function commit(bytes32 commitment) external {
        commits[msg.sender] = commitment;
        commitBlock[msg.sender] = block.number;
    }

    // Phase 2: Reveal your answer after some blocks have passed
    // Now it's too late for frontrunners — you already committed!
    function reveal(string memory answer, string memory secret) external {
        require(block.number > commitBlock[msg.sender] + 5, "Wait longer");
        require(
            commits[msg.sender] == keccak256(abi.encodePacked(answer, secret)),
            "Commitment mismatch"
        );
        require(
            keccak256(abi.encodePacked(answer)) == hashedAnswer,
            "Wrong answer"
        );

        (bool sent, ) = msg.sender.call{value: 1 ether}("");
        require(sent, "Transfer failed");
    }
}
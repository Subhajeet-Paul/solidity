// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract VoteProposal
{
	mapping(uint => mapping(address => bool)) public hasVoted;
	
	function vote(uint proposalId) public {
    hasVoted[proposalId][msg.sender] = true;
	}
}
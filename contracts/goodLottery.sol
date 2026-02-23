// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GoodLottery {
    mapping(address => uint256) public pendingWithdrawals;

    // Called by owner/game logic to record winnings
    function assignPrize(address winner, uint256 amount) public {
        pendingWithdrawals[winner] += amount;
    }
    
    // Each user calls this themselves to claim their prize
    function withdraw() public {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        // CEI pattern: update state before transfer
        pendingWithdrawals[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
    function declareWinner(address winner) public {
    assignPrize(winner, 1 ether);
}
}
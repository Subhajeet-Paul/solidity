// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendEther {
	constructor() payable {}
	receive() external payable {}
	
	function sendEther(address payable _to, uint _amount) external {
        require(address(this).balance >= _amount, "Insufficient balance");

        (bool success, ) = _to.call{value: _amount}(""); //call function line
        require(success, "Transfer failed");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
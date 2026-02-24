
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Logger {
    address public lastCaller;  // slot 0

    function logCaller() external {
        lastCaller = msg.sender; // who called THIS contract?
    }
}

contract Proxy {
    address public lastCaller;  // slot 0

    function forward(address logger) external {
        // msg.sender inside logCaller will be the ORIGINAL caller,
        // not the Proxy — delegatecall preserves it
        logger.delegatecall(abi.encodeWithSelector(Logger.logCaller.selector));
    }
}
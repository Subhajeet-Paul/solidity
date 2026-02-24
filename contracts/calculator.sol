// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ─── Logic Contract ───────────────────────────────────────────────────────────

contract Calculator {
    uint256 public result; // storage slot 0

    function add(uint256 a, uint256 b) external {
        result = a + b;
    }
}

// ─── Proxy Contract ───────────────────────────────────────────────────────────

contract Proxy {
    uint256 public result; // storage slot 0 — must mirror Calculator!

    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function addViaProxy(uint256 a, uint256 b) external {
        bytes memory payload = abi.encodeWithSelector(
            Calculator.add.selector, // bytes4 selector for add(uint256,uint256)
            a,
            b
        );

        (bool success, ) = implementation.delegatecall(payload);
        require(success, "delegatecall failed");
    }
}
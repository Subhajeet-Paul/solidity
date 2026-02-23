
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract compare{
    bytes32 a = keccak256("hello"); //keccak256 is a hashing algorithm
bytes32 b = keccak256("hello");
bool equal = (a == b); // direct == works!
}

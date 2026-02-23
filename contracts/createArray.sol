
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract DynamicArray {
    uint[] public numbers;

    function addNumber(uint _num) public {
        numbers.push(_num);
    }
    
    function getArray() public view returns(uint[] memory) {
        return numbers;
    }
}
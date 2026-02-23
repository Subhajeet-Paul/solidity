// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ReverseArray {

    uint[] public numbers;

    function addNumber(uint _num) public {
        numbers.push(_num);
    }
    
    function reverseArray() public {
        uint i=0;
        uint j=numbers.length-1;
        while(i<j){
            uint temp=numbers[i];
            numbers[i]=numbers[j];
            numbers[j]=temp;
            i++;
            j--;
        }
	   
    }}    
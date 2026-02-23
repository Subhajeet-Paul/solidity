
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract AgeMapping {

    mapping(address => uint) public age;

    function setAge(uint _age) public {
        age[msg.sender]=_age;
    }
    
    function getAge(address _user) public view returns (uint) {
        return age[_user];
    }
}
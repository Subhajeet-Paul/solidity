// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract structure{
    struct mystruct{
        string name;
        bool value;
        uint64 num;
    }

    mystruct public p1= mystruct("lucifer",true,12345);

    function getName() public view returns(string memory){
        return(p1.name);
    }
    function getAllData() public view returns(string memory,bool,uint64){
        return(p1.name,p1.value,p1.num);
    }
    function createNode(string memory _name,bool _value,uint64 _num) public pure returns(string memory){
        mystruct memory p1= mystruct(_name,_value,_num);
    }
}
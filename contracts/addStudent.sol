// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract StudentData {

    struct Student {
        string name;
        uint marks;
    }

    Student[] public students;

    function addStudent(string memory _name, uint _marks) public {
        students.push(Student(_name, _marks));
    }
}
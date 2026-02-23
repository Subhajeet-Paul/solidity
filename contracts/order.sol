// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract pr_enum{
    enum order{pending, filled, cancelled}
    order public status;
    function setShipped() public {
        status= order.filled;
    }
    function setCancelled(uint _value) public {
        require(_value < 3, "Invalid value!");
        status = order(_value);
    }
}
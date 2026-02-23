// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Q3 {

    enum Stage { Start, Middle, End }

    Stage public stage;
    function nextStage() public {
        if(stage == Stage.Start) {
            stage=Stage.Middle;
        }
        else if(stage == Stage.Middle) {
            stage=Stage.End;
        }
        else if(stage == Stage.End) {
           stage=Stage.Start;
        }
    }
}
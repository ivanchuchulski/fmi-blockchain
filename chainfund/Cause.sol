// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

struct Cause {
    address payable beneficiary;
    uint256 goal;
    uint256 currentAmount;
    bool isGoalReached;
}
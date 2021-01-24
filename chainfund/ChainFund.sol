// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

import "./Cause.sol";

// 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF
contract ChainFund {
    uint256 private numCauses;
    mapping(uint256 => Cause) private causes;

    constructor() {
        numCauses = 0;
    }

    function addCause(address payable beneficiary, uint256 goal) public returns (uint256 campaignID) {
        // Creates new struct in memory and copies it to storage.
        // We leave out the mapping type, because it is not valid in memory.
        // If structs are copied (even from storage to storage), mapping types
        // are always omitted, because they cannot be enumerated.

        // campaignID is return variable
        campaignID = numCauses++;
        causes[campaignID] = Cause(beneficiary, goal, 0, false);
    }

    function donateToCause(uint256 causeID) public payable {
        uint256 donationAmount = msg.value;

        Cause storage cause = causes[causeID];

        cause.currentAmount += donationAmount;

        checkGoalReached(causeID);
    }

    function checkGoalReached(uint causeID) public returns (bool reached) {
        Cause storage cause = causes[causeID];

        if (cause.currentAmount < cause.goal) {
            return false;
        }

        uint256 amount = cause.currentAmount;

        cause.currentAmount = 0;
        cause.beneficiary.transfer(amount);

        return true;
    }
}
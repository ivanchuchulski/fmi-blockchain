// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

import "./Cause.sol";

contract ChainFund {
    uint256 private numCauses;
    mapping(string => Cause) private causes;
    string[] private registeredCauses;

    constructor() {
        numCauses = 0;
    }

    function addCause(address payable beneficiary, uint256 goal, string memory description) public {
        require(!isCauseRegistered(description), "error : cause already registered");

        registeredCauses.push(description);
        causes[description] = Cause(description, beneficiary, goal, 0);
    }

    function donateToCause(string memory description) public payable {
        require(isCauseRegistered(description), "error : not such cause registered");

        Cause storage cause = causes[description];
        address sender = msg.sender;
        uint256 value = msg.value;

        cause.currentAmount += value;

        if (checkGoalReached(cause)) {
            transferCauseDonations(cause);
            // TODO : remove cause from registered causes
        }
    }

    function isCauseGoalReached(string memory description) public view returns (bool reached) {
        require(isCauseRegistered(description), "error : not such cause registered");

        Cause storage cause = causes[description];

        return cause.currentAmount >= cause.goal;
    }

    function checkCauseProgress(string memory description) public view returns (uint) {
        require(isCauseRegistered(description), "error : not such cause registered");

        Cause storage cause = causes[description];

        return cause.currentAmount;
    }


    function isCauseRegistered(string memory description) private view returns (bool) {
        for (uint256 i = 0; i < registeredCauses.length; i++) {
            if (keccak256(abi.encodePacked(registeredCauses[i])) == keccak256(abi.encodePacked(description))) {
                return true;
            }
        }

        return false;
    }


    function checkGoalReached(Cause storage cause) private view returns (bool reached) {
        return cause.currentAmount >= cause.goal;
    }

    function transferCauseDonations(Cause storage cause) private {
        uint256 amount = cause.currentAmount;

        cause.beneficiary.transfer(amount);
    }



}
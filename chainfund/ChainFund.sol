// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

import "./Cause.sol";
import "./Donation.sol";

contract ChainFund {
    uint256 private numCauses;
    mapping(string => Cause) private causes;
    string[] private registeredCauses;
    string[] private finishedCauses;

    mapping (string => Donation[]) causeDonators;

    constructor() {
        numCauses = 0;
    }

    function addCause(address payable beneficiary, uint256 goal, string memory description) public {
        require(!isCauseRegistered(description), "error : cause already registered");
        require(isCauseFinished(description), "error : cause already finished");

        registeredCauses.push(description);
        causes[description] = Cause(description, beneficiary, goal, 0);
    }

    function donateToCause(string memory description) public payable {
        require(isCauseRegistered(description), "error : not such cause registered");
        require(!isCauseFinished(description), "error : cause already finished");
    
        Cause storage cause = causes[description];
        address sender = msg.sender;
        uint256 value = msg.value;

        Donation[] storage donatorsForCause = causeDonators[cause.description];

        cause.currentAmount += value;
        donatorsForCause.push(Donation(sender, value, block.timestamp));

        if (checkGoalReached(cause)) {
            transferCauseDonations(cause);
            
            // TODO : handle finished causes
            finishedCauses.push(cause.description);
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

    // this does not work on like that, we can either destrcutively return the donations or use experimental feature
    // function getDonationsForCause(string memory description) public view returns (Donation[] memory) {
        
    // }


    function isCauseRegistered(string memory description) private view returns (bool) {
        for (uint256 i = 0; i < registeredCauses.length; i++) {
            if (strCompare(registeredCauses[i], description)) {
                return true;
            }
        }

        return false;
    }
    
    function isCauseFinished(string memory description) private view returns (bool) {
        for (uint256 i = 0; i < registeredCauses.length; i++) {
            if (strCompare(finishedCauses[i], description)) {
                return true;
            }
        }

        return false;
    }
    
    function strCompare(string memory left, string memory right) private pure returns (bool) {
      return keccak256(abi.encodePacked(left)) == keccak256(abi.encodePacked(right));
    }


    function checkGoalReached(Cause storage cause) private view returns (bool reached) {
        return cause.currentAmount >= cause.goal;
    }

    function transferCauseDonations(Cause storage cause) private {
        uint256 amount = cause.currentAmount;

        cause.beneficiary.transfer(amount);
    }



}
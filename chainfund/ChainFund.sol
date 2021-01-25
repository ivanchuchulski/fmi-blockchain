// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;
pragma experimental ABIEncoderV2;

import "./Cause.sol";
import "./Donation.sol";

contract ChainFund {
    string[] private registeredCauses;
    string[] private finishedCauses;

    mapping(string => Cause) private causes;
    mapping(string => Donation[]) private causeDonators;

    constructor() {
    }

    function addCause(address payable beneficiary, uint256 goal, string memory title) public {
        require(!isCauseRegistered(title), "error : cause already registered");

        registeredCauses.push(title);
        causes[title] = Cause(title, beneficiary, goal, 0);
    }

    function donateToCause(string memory title) public payable {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        Cause storage cause = causes[title];
        address sender = msg.sender;
        uint256 value = msg.value;

        Donation[] storage donatorsForCause = causeDonators[cause.title];

        cause.currentAmount += value;
        donatorsForCause.push(Donation(sender, value, block.timestamp));

        if (checkGoalReached(cause)) {
            transferCauseDonations(cause);
            finishedCauses.push(cause.title);
        }
    }

    function isCauseGoalReached(string memory title) public view returns (bool reached) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Cause storage cause = causes[title];

        return checkGoalReached(cause);
    }

    function checkCauseProgress(string memory title) public view returns (uint) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Cause storage cause = causes[title];

        return cause.currentAmount;
    }

    function getNumberOfRegisteredCauses() public view returns (uint256) {
        return registeredCauses.length;
    }

    function getNumberOfFinishedCauses() public view returns (uint256) {
        return finishedCauses.length;
    }

    // uses the experimental feature
    function getDonationsForCauseExperimental(string memory title) public view returns (Donation[] memory) {
        require(isCauseRegistered(title), "error : not such cause registered");

        return causeDonators[title];
    }

    function getDonationsForCause(string memory title) public view returns (address[] memory, uint256[] memory, uint256[] memory) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Donation[] storage donationsForCause = causeDonators[title];

        address[] memory addresses = new address[](donationsForCause.length);
        uint[] memory donationAmounts = new uint[](donationsForCause.length);
        uint[] memory donationTimestamps = new uint[](donationsForCause.length);

        for (uint256 i = 0; i < donationsForCause.length; i++) {
            addresses[i] = donationsForCause[i].donator;
            donationAmounts[i] = donationsForCause[i].amount;
            donationTimestamps[i] = donationsForCause[i].timestamp;
        }

        return (addresses, donationAmounts, donationTimestamps);
    }


    function isCauseRegistered(string memory title) private view returns (bool) {
        for (uint256 i = 0; i < registeredCauses.length; i++) {
            if (strCompare(registeredCauses[i], title)) {
                return true;
            }
        }

        return false;
    }

    function isCauseFinished(string memory title) private view returns (bool) {
        for (uint256 i = 0; i < finishedCauses.length; i++) {
            if (strCompare(finishedCauses[i], title)) {
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
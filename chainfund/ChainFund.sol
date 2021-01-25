// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

import "./Cause.sol";
import "./Donation.sol";

contract ChainFund {
    uint256 private constant SECONDS_IN_DAY =  24 * 60 * 60;
    string[] private registeredCauses;
    mapping(string => bool) private registeredCausesMap;

    string[] private finishedCauses;
    mapping(string => bool) private finishedCausesMap;

    mapping(string => Cause) private causes;
    mapping(string => Donation[]) private causeDonators;

    constructor() {
    }

    function addCause(string memory title, address payable beneficiary, uint256 goal, uint256 deadlineInDays) public {
        require(!isCauseRegistered(title), "error : cause already registered");

        causes[title] = Cause(title, beneficiary, goal, 0, deadlineInDays * SECONDS_IN_DAY + block.timestamp);
        registeredCauses.push(title);
        registeredCausesMap[title] = true;
    }

    function donateToCause(string memory title) public payable {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        address sender = msg.sender;
        uint256 value = msg.value;

        Cause storage cause = causes[title];
        Donation[] storage donatorsForCause = causeDonators[cause.title];

        if (cause.deadlineTimestamp < block.timestamp) {
            transferCauseDonations(cause);

            finishedCauses.push(cause.title);
            finishedCausesMap[title] = true;
            return;
        }

        cause.currentAmount += value;
        donatorsForCause.push(Donation(sender, value, block.timestamp));

        if (checkGoalReached(cause)) {
            transferCauseDonations(cause);

            finishedCauses.push(cause.title);
            finishedCausesMap[title] = true;
        }
    }

    function cancelCause(string memory title) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        address sender = msg.sender;
        Cause storage cause = causes[title];

        if (cause.beneficiary == sender) {
            transferCauseDonations(cause);

            finishedCauses.push(cause.title);
            finishedCausesMap[title] = true;

            return true;
        } else {
            return false;
        }
    }

    function extendCauseDeadline(string memory title, uint256 daysToExtend) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        address sender = msg.sender;
        Cause storage cause = causes[title];

        if (cause.beneficiary == sender) {
            cause.deadlineTimestamp += daysToExtend * SECONDS_IN_DAY;
            return true;
        } else {
            return false;
        }
    }

    function extendCauseGoal(string memory title, uint256 goalExtension) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        address sender = msg.sender;
        Cause storage cause = causes[title];

        if (cause.beneficiary == sender) {
            cause.goal += goalExtension;
            return true;
        } else {
            return false;
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

    function checkCauseGoal(string memory title) public view returns (uint) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Cause storage cause = causes[title];

        return cause.goal;
    }

    function getCauseDeadline(string memory title) public view returns (uint256) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Cause storage cause = causes[title];

        return cause.deadlineTimestamp;
    }

    function getCauseDeadlineInDays(string memory title) public view returns (uint256) {
        require(isCauseRegistered(title), "error : not such cause registered");

        Cause storage cause = causes[title];

        if (cause.deadlineTimestamp < block.timestamp) {
            return 0;
        } else {
            // integer division so it truncates
            return (cause.deadlineTimestamp - block.timestamp) / SECONDS_IN_DAY;
        }
    }

    function getNumberOfRegisteredCauses() public view returns (uint256) {
        return registeredCauses.length;
    }

    function getNumberOfFinishedCauses() public view returns (uint256) {
        return finishedCauses.length;
    }

    function getBlockTimeStamp() public view returns (uint256) {
        return block.timestamp;
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
        return registeredCausesMap[title];
    }

    function isCauseFinished(string memory title) private view returns (bool) {
        return finishedCausesMap[title];
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
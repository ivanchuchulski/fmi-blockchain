// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.6 <0.8.0;

import "./Cause.sol";
import "./Donation.sol";

contract ChainFund {
    uint256 private constant SECONDS_IN_DAY = 24 * 60 * 60;

    uint256 private registeredCausesCount;
    uint256 private finishedCausesCount;

    mapping(string => bool) private registeredCausesMap;
    mapping(string => bool) private finishedCausesMap;

    mapping(string => Cause) private causes;
    mapping(string => Donation[]) private causeDonators;

    constructor() {
        registeredCausesCount = 0;
        finishedCausesCount = 0;
    }

    function addCause(string memory title, address creator, address payable beneficiary, uint256 goal, uint256 deadlineInDays) public {
        require(!isCauseRegistered(title), "error : cause already registered");

        causes[title] = Cause(title, creator, beneficiary, goal, 0, deadlineInDays * SECONDS_IN_DAY + block.timestamp);
        registeredCausesCount++;
        registeredCausesMap[title] = true;
    }

    // maybe add require the donator to not be the cause creator or beneficiary
    function donateToCause(string memory title) public payable {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        Cause storage cause = causes[title];

        if (cause.deadlineTimestamp < block.timestamp) {
            transferCauseDonations(cause);
            addCauseToFinished(title);
            return;
        }

        address sender = msg.sender;
        uint256 value = msg.value;
        Donation[] storage donatorsForCause = causeDonators[cause.title];

        cause.currentAmount += value;
        donatorsForCause.push(Donation(sender, value, block.timestamp));

        if (checkGoalReached(cause)) {
            transferCauseDonations(cause);
            addCauseToFinished(title);
        }
    }

    function stopCause(string memory title) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        Cause storage cause = causes[title];

        require(cause.creator == msg.sender, "error : to stop the cause you have to be the cause creator");

        transferCauseDonations(cause);
        addCauseToFinished(title);

        return true;
    }

    function extendCauseDeadline(string memory title, uint256 daysToExtend) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        Cause storage cause = causes[title];

        require(cause.creator == msg.sender, "error : to extend the deadline you have to be the cause creator");

        cause.deadlineTimestamp += daysToExtend * SECONDS_IN_DAY;
        return true;
    }

    function extendCauseGoal(string memory title, uint256 goalExtension) public payable returns (bool) {
        require(isCauseRegistered(title), "error : not such cause registered");
        require(!isCauseFinished(title), "error : cause already finished");

        Cause storage cause = causes[title];

        require(cause.creator == msg.sender, "error : to extend the goal you have to be the cause creator");

        cause.goal += goalExtension;
        return true;
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
        return registeredCausesCount;
    }

    function getNumberOfFinishedCauses() public view returns (uint256) {
        return finishedCausesCount;
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

    // private helpers
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

    function addCauseToFinished(string memory title) private {
        finishedCausesCount++;
        finishedCausesMap[title] = true;
    }
}
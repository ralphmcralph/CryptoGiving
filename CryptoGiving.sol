// License
// SPDX-License-Identifier: LGPL-3.0-only

// Solidity version
pragma solidity 0.8.24;

// Smart Contract Definition
contract CryptoGiving {

// Variables

// Donations mapping
mapping (address => uint) public donations;

// Owner address
address public owner;

// Goal setting
uint goal = 90 ether;

bool public goalReached;

uint constant MIN_DONATION = 0.001 ether;

// Constructor
constructor(uint _goal) {
    
    // Avoid goal to be lower than zero
    require(_goal > 0, "Goal must be greater than 0");    
    // Ownership is assigned to address that deploys
    owner = msg.sender;
    goal = _goal * 0.1 ether; // Type 5 for 0.5 ether

}

// MODIFIERS

modifier donationTooSmall(uint _value) {
    require(_value >= MIN_DONATION, "Donation must be at least 0.001 ether");
    _;
    
}

modifier onlyOwner {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
}

modifier checkGoalReached {
    require(!goalReached, "Goal has already been reached");
    _;
}

// EVENTS
event DonationReceived(address donor, uint amount, string message);

event GoalReached (uint totalBalance);

// FUNCTIONS - External

function donate() donationTooSmall(msg.value) checkGoalReached external payable {
    
    uint donationAmount = msg.value;

    // If donation is higher than the remaining amount, refund the rest to donor
    if(address(this).balance > goal) {
        uint refundAmount = address(this).balance - goal;

        donationAmount = msg.value - refundAmount;

        payable(msg.sender).transfer(refundAmount);

        goalReached = true;

        emit GoalReached(address(this).balance);

    }

    donations[msg.sender] += donationAmount;

    // Customize reward message based on donation amount
    string memory rewardMessage;
    if (donationAmount >= 0.1 ether) {
        rewardMessage = "You are an amazing donor, thank you!";
    } else if (donationAmount >= 0.01 ether) {
        rewardMessage = "Thank you for your generous contribution!";
    } else {
        rewardMessage = "Thanks for your donation!";
    }

    emit DonationReceived(msg.sender, donationAmount, rewardMessage);

}

// Restrict withdrawal to owner
function withdraw() onlyOwner external {
    // Transfer balance to owner
    require(address(this).balance > 0, "No funds to withdraw");
    payable(owner).transfer(address(this).balance);
}

function getContractBalance() external view returns (uint) {
    return address(this).balance;
}

}
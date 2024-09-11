// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FortuneCookie {
    
    string[] private fortunes;
    string public specialFortune = "You've unlocked the ultimate fortune! No exams, A+ in every subject, and you're placed in your dream company with a 7-figure salary!";
    address public owner;
    uint private interactionCounter;
    uint private lastInteractionTimestamp;
    
    // Mapping to store fortunes for each user
    mapping(address => string[]) private userFortunes;

    constructor() {
        owner = msg.sender;
        fortunes = [
            "Mass bunk is happening tomorrow. Don't set your alarm!",
            "Your group will actually finish the project the night before!",
            "Free food alert on campus! Follow the crowd.",
            "The professor will forget about the assignment deadline!",
            "Your favorite snack will be available in the vending machine today!",
            "Surprise holiday incoming! Get ready to chill.",
            "You will get the best seat in class right next to the AC!",
            "Today's class will be cancelled for technical reasons.",
            "Your procrastination will finally pay off!",
            "Your favorite coffee spot will have a 'buy one, get one free' deal.",
            "Lecture will turn into a movie day. Get the popcorn ready!",
            "An unexpected campus fest is about to make your day!"
        ];
        interactionCounter = 0;
        lastInteractionTimestamp = block.timestamp;
    }

    // Function to get a random fortune or the special fortune and store it
    function openFortuneCookie() public returns (string memory) {
        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, interactionCounter))) % fortunes.length;
        interactionCounter++;
        lastInteractionTimestamp = block.timestamp;  // Update timestamp

        // Generate a pseudo-random number for special fortune chance
        uint randomSeed = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, interactionCounter, lastInteractionTimestamp)));
        
        string memory selectedFortune;
        
        // 1 in 100 chance to get the special fortune
        if (randomSeed % 100 == 0) {  
            selectedFortune = specialFortune;
        } else {
            selectedFortune = fortunes[randomIndex];
        }

        // Store the selected fortune in the user's fortune history
        userFortunes[msg.sender].push(selectedFortune);

        return selectedFortune;
    }

    // Function to allow the owner to add new fortunes
    function addFortune(string memory newFortune) public {
        require(msg.sender == owner, "Only the owner can add new fortunes!");
        fortunes.push(newFortune);
    }

    // Function to retrieve all fortunes a user has received
    function getMyFortunes() public view returns (string[] memory) {
        return userFortunes[msg.sender];
    }
}

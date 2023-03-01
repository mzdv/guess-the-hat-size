// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "hardhat/console.sol";
contract HatSizeGame {
    
    event UserPays(
        address indexed user,
        uint256 amountPaid,
        uint256 gasLeft,
        uint256 timestamp
    );

    event Winner(
        address indexed winner,
        uint256 amountWon,
        uint256 gasLeft,
        uint256 timestamp
    );

    event Loser(
        address indexed winner,
        uint256 gasLeft,
        uint256 timestamp,
        string hatStatus
    );

    uint16 secretNumber;    // TODO: access control

    function changeSecretNumber(uint16 newSecretNumber) public {    // TODO: access control for contract owner
        secretNumber = newSecretNumber;
    }

    function guessTheHatSize(uint16 numberToGuess) public payable returns (bool) {
        emit UserPays(msg.sender, msg.value, gasleft(), block.timestamp);

        if (numberToGuess == secretNumber) {
            uint256 amountWon = 5;  // TODO: amount won algorithm
            emit Winner(msg.sender, amountWon, gasleft(), block.timestamp);
            // TODO: Transfer tokens
        }
        else {

            // Just a funny message, nothing more
            string memory hatStatus = (numberToGuess < secretNumber ? "You've got a big hat to fill, eh?" : "Wow, slow down with the hat size!");

            emit Loser(msg.sender, gasleft(), block.timestamp, hatStatus);
        }
    }
}
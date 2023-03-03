// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./HatSizeToken.sol";

contract HatSizeGame is AccessControl {
    // Possible ideas for improvement on the smart contract
    // 1) leaderboard by addresses who has played the most and who has paid the most
    // 2) winnings tracker per address and per game
    // 3) keeping track of successive wins that increase the payout for each continuous success
    // 4) auto-mint HST tokens when needed

    bytes32 public constant HOUSE_ROLE = keccak256("HOUSE_ROLE");   // Contract owner role

    HatSizeToken hst;
    uint16 HST_WIN_AMOUNT = 100;

    uint16 secretNumber;    // We gotta give the players some illusion of hope, 1/65535 are good odds
    uint256 totalHouseMoney;

    string winningMessage;

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
        uint256 timestamp,
        string winningMessage
    );

    event Loser(
        address indexed winner,
        uint256 gasLeft,
        uint256 timestamp,
        string hatStatus
    );

    constructor(address hatSizeLiquidityAddress) {
        _grantRole(HOUSE_ROLE, msg.sender);

        totalHouseMoney = 0;
        winningMessage = "Congratulations! You guessed the hat size!";

        hst = HatSizeToken(hatSizeLiquidityAddress);
    }

    function changeSecretNumber(
        uint16 newSecretNumber
    ) public onlyRole(HOUSE_ROLE) {
        secretNumber = newSecretNumber;
    }

    function guessTheHatSize(
        uint16 numberToGuess,
        address payable addressToPay
    ) public payable returns (bool) {
        require(
            msg.value > 0.01 ether,
            "Raise your stakes! At least 0.01 Ether to guess the hat size"
        );

        console.log('Entered the game');
        console.log('Secret number %s', secretNumber);
        console.log('Sent number %s', numberToGuess);
        console.log('Sent ether %s', msg.value);
        console.log('Sender %s', msg.sender);

        bool result = false;

        emit UserPays(msg.sender, msg.value, gasleft(), block.timestamp);

        if (numberToGuess == secretNumber) {
            console.log('Success branch');
            // No need to check if the house has money since we have to pay to play
            // As long as someone games, there will be money
            uint256 amountWon = (msg.value * 8) / 10;
            console.log('Won amount %s', amountWon);

            totalHouseMoney += msg.value - amountWon;
            console.log('House balance %s', totalHouseMoney);
            
            require(hst.balanceOf(address(this)) < 100, "No Hat Size Tokens available! Please inform the admin");
        
            emit Winner(msg.sender, amountWon, gasleft(), block.timestamp, winningMessage);

            addressToPay.transfer(amountWon);
            hst.transfer(msg.sender, HST_WIN_AMOUNT);

            result = true;
        } else {
            console.log('Fail branch');

            totalHouseMoney += msg.value;

            // Just a funny message, nothing more
            string memory hatStatus = (
                numberToGuess < secretNumber
                    ? "You've got a big hat to fill, eh?"
                    : "Wow, slow down with the hat size!"
            );

            emit Loser(msg.sender, gasleft(), block.timestamp, hatStatus);
        }

        return result;
    }
}

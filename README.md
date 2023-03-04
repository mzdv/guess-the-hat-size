# Guess the Hat size blockchain game!

## Introduction

This project is a (partially) successfull implementation of an ERC20 token
that utilizes an external smart contract depending on ZKSync. The project is managed by
Hardhat. The languages used are Solidity for smart contracts and Javascript for
supporting code.

Smart contracts are flattened into a single file and prepared for verification.

**Note: you will find some keys and addresses in this repository. They're empty,
so don't try your luck.**

## Problem description

There should be two smart contracts - one that mints a new ERC20 token (HST, 
Hat Size Token) with all
of the fun new features (such as pausability) and a second one that provides game
logic for a guessing game. 

To make it more fun, the guessing game is called 'Guess the Hat size'. The owner
of the smart contract produces a number that has to be guessed by the player.
The player pays a small fee of at least 0.01 ETH to play. If the player guesses,
the contract transfers 80% of the contract value + 100 HST (Hat Size Tokens).
If the player doesn't guess the number, nothing happens and no money is returned.

The game contract emits several events that appear when key points are reached
in the application.

Hat Size Token is a generic ERC20 token that can be minted by the owner of the
contract (the person that deployed it). There is also a feature to 'motivate'
the player of the game by transferring tokens to his address. This is at the sole
discretion of the minter.

## How do I run it?

Prerequisites: be sure to have a Wallet on the Goerli network with some ETH on it,
that is a prerequisite for deployment.

There are two sets of scripts: `scripts/deployBasic.js` and `deploy/deploy.js`

The `deployBasic.js` script handles regular Hardhat deployment without the
ZkSync network, while the `deploy.js` handles ZkSync deployment.

Before everything, download the dependencies by running `npm install`

### Regular deployment

* Figure out are you deploying it locally to the hardhat node or somewhere else
(e.g. goerli)
* If deploying to local node: `npx hardhat node`. This runs a Hardhat note
* `npx hardhat scripts/deployBasic.js`

* If deploying to somewhere else (e.g. goerli)
* Fill out the `hardhat.config.js` with the necessary fields for the target network
* In case of `goerli`, the run command is the following `npx hardhat run scripts/deployBasic.js --network goerli`

### ZkSync testnet

* Make sure you have ETH on the Goerli testnet, otherwise there will be an 
`INSUFFICIENT_FUNDS` error
* `npx hardhat deploy-zksync`

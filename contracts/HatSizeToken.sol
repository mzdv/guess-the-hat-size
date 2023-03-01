// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract HatSizeToken is ERC20, ERC20Burnable, Pausable, AccessControl {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    address private house;

    constructor() ERC20("HatSizeToken", "HST") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);

        house = msg.sender;

        // The house always has money
        _mint(house, 1000000 * 10 ** decimals());

        _grantRole(MINTER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // The house has the power to create tokens in order to cover their positions
    function increaseHouseLiquidity(uint256 amount) public onlyRole(MINTER_ROLE) {
        mint(house, amount);
    }

    // Sometimes our beloved players get a little bit down, so we need to motivate
    // them to play more. Since there isn't a way to send free drinks via the blockchain,
    // we can send them some tokens down the line. The house always wins, so we
    // materialize tokens out of thin air, without letting anyone know, thus
    // being able to keep the exchange rate as we wish
    function motivatePlayer(address player, uint256 amount) public onlyRole(MINTER_ROLE) {
        increaseHouseLiquidity(amount);
        _transfer(house, player, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
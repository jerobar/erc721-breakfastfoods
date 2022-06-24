// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Implementation of the ERC20 Token Standard for 'BreakfastCoinStaking'.
 */
contract BreakfastCoinStaking is ERC20 {
    mapping(address => bool) private _mintingAddresses;

    address immutable deployer;

    /**
     * @dev Calls `ERC20` constructor to set valus for {_name}, {_symbol},
     * sets `seployer` to `msg.sender` and adds `deployer` to list of
     * approved minters.
     */
    constructor() ERC20("BreakfastCoin", "BRKFST") {
        deployer = msg.sender;
        _mintingAddresses[msg.sender] = true;
    }

    /**
     * @dev Requires `minter` address is an approved minter.
     */
    modifier canMint(address minter) {
        require(
            _mintingAddresses[msg.sender],
            "BreakfastCoinStaking: Feature only available to minting addresses"
        );
        _;
    }

    /**
     * @dev Adds `minter` to approved minting addresses.
     *
     * Requirements:
     *
     * - `canMint` modifier
     */
    function addMintingAddress(address minter) external canMint(msg.sender) {
        _mintingAddresses[minter] = true;
    }

    /**
     * @dev Mints `amount` tokens to address `to`.
     *
     * Requirements:
     *
     * - `canMint` modifier
     */
    function mintToAddress(uint amount, address to)
        public
        virtual
        canMint(msg.sender)
    {
        _mint(to, amount);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Implementation of the ERC20 Token Standard for 'BreakfastCoinStaking'.
 */
contract BreakfastCoinStaking is ERC20 {
    mapping(address => bool) private _canMint;

    address immutable deployer;

    /**
     * @dev Calls `ERC20` constructor to set valus for {_name}, {_symbol}.
     */
    constructor() ERC20("BreakfastCoin", "BRKFST") {
        deployer = msg.sender;
    }

    /**
     * @dev Mints `amount` tokens to address `to`.
     */
    function mintToAddress(uint amount, address to) public virtual {
        _mint(to, amount);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BreakfastCoin is ERC20 {
    /**
     * @dev Calls `ERC20` constructor to set valus for {_name}, {_symbol}.
     */
    constructor() ERC20("BreakfastCoin", "BRKFST") {}

    /**
     * @dev Mints `amount` tokens to `msg.sender`.
     */
    function mint(uint amount) public virtual {
        _mint(msg.sender, amount);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./BreakfastFoodsNFT.sol";

/**
 * @dev 'BreakfastFoodsNFTFree' implementation of the 'BreakfastFoodsNFT' token.
 *
 * Allows tokens to be minted for free by any caller.
 */
contract BreakfastFoodsNFTFree is BreakfastFoodsNFT {
    /**
     * @dev Mints token `tokenSupply` to `msg.sender`.
     *
     * Requirements:
     *
     * - `tokenSupply` < `MAX_TOKEN_SUPPLY`
     */
    function mint() external {
        require(
            tokenSupply < MAX_TOKEN_SUPPLY,
            "BreakfastFoodsNFTFree: Token supply cap met"
        );

        _mint(msg.sender, tokenSupply);
        tokenSupply += 1;
    }
}

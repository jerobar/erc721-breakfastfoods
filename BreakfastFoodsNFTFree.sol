// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./BreakfastFoodsNFT.sol";

contract BreakfastFoodsNFTFree is BreakfastFoodsNFT {
    function mint() external {
        require(
            tokenSupply < MAX_TOKEN_SUPPLY,
            "BreakfastFoodsNFT: Token supply cap met"
        );

        _mint(msg.sender, tokenSupply);
        tokenSupply += 1;
    }
}

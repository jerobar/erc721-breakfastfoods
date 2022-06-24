// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./BreakfastFoodsNFT.sol";
import "./BreakfastCoin.sol";

/**
 * @dev 'BreakfastFoodsNFTCoin' implementation of the 'BreakfastFoodsNFT' token.
 *
 * Allows a token to be minted for 10 'BreakfastCoin' tokens.
 */
contract BreakfastFoodsNFTCoin is BreakfastFoodsNFT {
    BreakfastCoin public breakfastCoinContract;
    address immutable deployer;

    /**
     * @dev Sets value of `breakfastCoinContract` and `deployer`.
     */
    constructor(address breakfastCoinContractAddress) {
        breakfastCoinContract = BreakfastCoin(breakfastCoinContractAddress);
        deployer = msg.sender;
    }

    /**
     * @dev Mints token `tokenSupply` to `msg.sender`.
     *
     * Requirements:
     *
     * - `tokenSupply` < `MAX_TOKEN_SUPPLY`
     * - Contract address approved to transfer 10 'BreakfastCoin' tokens from `msg.sender`
     */
    function mint() external {
        require(
            tokenSupply < MAX_TOKEN_SUPPLY,
            "BreakfastFoodsNFTCoin: Token supply cap met"
        );

        // Transfer 10 'BreakfastCoin' tokens from `msg.sender` to contract address
        bool tokenTransferSuccess = breakfastCoinContract.transferFrom(
            msg.sender,
            address(this),
            10 ether
        );

        if (tokenTransferSuccess) {
            _mint(msg.sender, tokenSupply);
            tokenSupply += 1;
        } else {
            revert(
                "BreakfastFoodsNFTCoin: Could not transfer 10 'BreakfastCoin' tokens from address"
            );
        }
    }

    /**
     * @dev Allows deployer to transfer contract's 'BreakfastCoin' tokens to an EOA.
     */
    function transfer(address to, uint256 amount) external {
        require(
            msg.sender == deployer,
            "BreakfastFoodsNFTCoin: Feature only available to contract deployer"
        );

        breakfastCoinContract.transfer(to, amount);
    }
}

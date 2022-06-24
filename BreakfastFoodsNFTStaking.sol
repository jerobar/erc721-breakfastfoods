// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./BreakfastFoodsNFT.sol";
import "./BreakfastCoinStaking.sol";

/**
 * @dev 'BreakfastFoodsNFTStaking' implementation of the 'BreakfastFoodsNFT' token.
 *
 * Users may stake their NFTs to receieve 10 'BreakfastFoodCoin' tokens every 24 hours.
 */
contract BreakfastFoodsNFTStaking is BreakfastFoodsNFT {
    // Token ID => Staker address
    mapping(uint256 => address) private _stakedTokens;

    // Token ID => Earliest withdrawal time
    mapping(uint256 => uint256) private _withdrawalTimes;

    BreakfastCoinStaking public breakfastCoinContract;

    constructor(address breakfastCoinContractAddress) {
        breakfastCoinContract = BreakfastCoinStaking(
            breakfastCoinContractAddress
        );
    }

    function stake(uint256 tokenId) external {
        // Transfer token from `msg.sender` to contract address
        transferFrom(msg.sender, address(this), tokenId);

        _stakedTokens[tokenId] = msg.sender;
    }

    function withdrawBreakfastCoins(uint256 tokenId) external {
        require(
            _stakedTokens[tokenId] == msg.sender,
            "BreakfastFoodsNFTStaking: Caller has no staked tokens"
        );

        require(
            _withdrawalTimes[tokenId] <= block.timestamp,
            "BreakfastFoodsNFTStaking: Can only withdraw coins every 24 hours"
        );

        // Mint 10 'BreakfastCoin' tokens to `msg.sender`
        breakfastCoinContract.mintToAddress(10 ether, msg.sender);

        // Update `_withdrawalTimes` for this token
        _withdrawalTimes[tokenId] = block.timestamp + 24 hours;
    }

    function unstake(uint256 tokenId) external {
        // Transfer token from contract address to `msg.sender`
        transferFrom(address(this), msg.sender, tokenId);

        _stakedTokens[tokenId] = address(0);
    }
}

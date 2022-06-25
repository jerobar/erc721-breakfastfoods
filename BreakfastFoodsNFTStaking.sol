// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./BreakfastFoodsNFTFree.sol";
import "./BreakfastCoinStaking.sol";

/**
 * @dev 'BreakfastFoodsNFTStaking' implementation of the 'BreakfastFoodsNFT' token.
 *
 * Users may stake their NFTs to receieve 10 'BreakfastFoodCoin' tokens every 24 hours.
 */
contract BreakfastFoodsNFTStaking is BreakfastFoodsNFTFree {
    uint256 public constant REWARD_PERIOD = 24 hours;

    // Token ID => Staker address
    mapping(uint256 => address) private _stakedTokens;

    // Token ID => Earliest withdrawal time
    mapping(uint256 => uint256) private _withdrawalTimes;

    BreakfastCoinStaking public breakfastCoinContract;

    /**
     * @dev Sets value of `breakfastCoinContract`.
     */
    constructor(address breakfastCoinContractAddress) {
        breakfastCoinContract = BreakfastCoinStaking(
            breakfastCoinContractAddress
        );
    }

    /**
     * @dev Returns bool whether `tokenId` is currently staked.
     */
    function tokenIsStaked(uint256 tokenId) public view returns (bool) {
        return _stakedTokens[tokenId] != address(0);
    }

    /**
     * @dev Calculates number of staking reward periods that have elapsed
     * since the earliest withdrawal timestamp.
     *
     * Returns uint256 reward periods elapsed.
     */
    function rewardPeriodsElapsed(uint256 tokenId)
        private
        view
        returns (uint256)
    {
        // Calculate total time elapsed since earliest withdrawal time
        uint256 timeElapsed = block.timestamp - _withdrawalTimes[tokenId];

        // Calculate how many additional 24 hour periods may have elapsed
        uint256 rewardPeriods = 1 + (timeElapsed / REWARD_PERIOD);

        return rewardPeriods;
    }

    /**
     * @dev Updates the withdrawal time for `tokenId`, accounting for any
     * time 'left over'.
     *
     * e.g. 50 hours = 2 reward periods and 2 hours 'left over' counting
     * toward next reward time.
     */
    function updateWithdrawalTimes(uint256 tokenId, uint256 rewardPeriods)
        private
    {
        // Calculate total time elapsed since earliest withdrawal time
        uint256 timeElapsed = block.timestamp - _withdrawalTimes[tokenId];
        // Calculate remaining time to account for in new withdrawal time
        uint256 leftOver = (block.timestamp - _withdrawalTimes[tokenId]) -
            (timeElapsed / REWARD_PERIOD);

        _withdrawalTimes[tokenId] =
            block.timestamp +
            (REWARD_PERIOD - leftOver);
    }

    /**
     * @dev Stakes 'BreakfastCoin' token `tokenId` on behalf of `msg.sender`.
     *
     * Note that `transferFrom` handles the requisite permissions checks.
     */
    function stake(uint256 tokenId) external {
        // Transfer token from `msg.sender` to contract address
        transferFrom(msg.sender, address(this), tokenId);

        _stakedTokens[tokenId] = msg.sender;
        _withdrawalTimes[tokenId] = block.timestamp + REWARD_PERIOD;
    }

    /**
     * @dev Allows 10 'BreakfastCoin' tokens to be minted to `msg.sender`
     * every 24 hours.
     *
     * Requirements:
     *
     * - Token `tokenId` is staked by `msg.sender`
     * - At least 24 hours have elapsed since staking or last withdrawal
     */
    function withdrawBreakfastCoins(uint256 tokenId) external {
        require(
            _stakedTokens[tokenId] == msg.sender,
            "BreakfastFoodsNFTStaking: Token not staked"
        );

        require(
            _withdrawalTimes[tokenId] <= block.timestamp,
            "BreakfastFoodsNFTStaking: Can only withdraw coins every 24 hours"
        );

        uint256 rewardPeriods = rewardPeriodsElapsed(tokenId);

        // Mint earned 'BreakfastCoin' tokens to `msg.sender`
        breakfastCoinContract.mintToAddress(
            rewardPeriods * 10 ether,
            msg.sender
        );

        updateWithdrawalTimes(tokenId, rewardPeriods);
    }

    /**
     * @dev Allows `msg.sender` to unstake token `tokenId`.
     *
     * Requirements:
     *
     * - Token `tokenId` is currently staked by `msg.sender`
     */
    function unstake(uint256 tokenId) external {
        require(
            _stakedTokens[tokenId] == msg.sender,
            "BreakfastFoodsNFTStaking: Token not staked by this address"
        );

        // Transfer token from contract address to `msg.sender`
        _transfer(address(this), msg.sender, tokenId);

        _stakedTokens[tokenId] = address(0);
    }
}

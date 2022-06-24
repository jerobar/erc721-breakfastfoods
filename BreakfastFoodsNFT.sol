// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @dev Implementation of the ERC721 Token Standard for 'BreakfastFoodsNFT'.
 */
contract BreakfastFoodsNFT is ERC721 {
    uint256 public tokenSupply = 0;
    uint256 public constant MAX_TOKEN_SUPPLY = 10;

    /**
     * @dev Calls `ERC721` constructor to set valus for {_name}, {_symbol}.
     */
    constructor() ERC721("BreakfastFoods", "BRKFST") {}

    /**
     * @dev Overrides `_baseURI` to set NFT collection URI.
     *
     * Returns string ipfs directory URI.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmaPrXV1mGXxNKyyuSjBKDAwwfmjYbkDn5wvDWMaKSWg9M/";
    }
}

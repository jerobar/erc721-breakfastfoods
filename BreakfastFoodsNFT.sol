// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BreakfastFoodsNFT is ERC721 {
    uint256 public tokenSupply = 0;
    uint256 public constant MAX_TOKEN_SUPPLY = 10;

    constructor() ERC721("BreakfastFoods", "BRKFST") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://<DIRECTORY_HASH_HERE>/";
    }
}

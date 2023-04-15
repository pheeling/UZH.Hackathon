// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PotNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public potCoin;

    modifier onlyPotCoin() {
      require(msg.sender == potCoin, "Only the pot coin can call this function.");
      _;
    }

    constructor(address _potCoin) ERC721("FixPot", "FPT") {
        potCoin = _potCoin;
    }

    function awardItem(address player, string memory tokenURI)
        public onlyPotCoin
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}
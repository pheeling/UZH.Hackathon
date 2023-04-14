// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "contracts/PotNFT.sol";

contract PotCoin is ERC20, AccessControl {
    PotNFT potNft;


    constructor(uint256 initialSupply, address nftContract) ERC20("PotCoin", "POT") {
        _mint(msg.sender, initialSupply);
        potNft = PotNFT(nftContract);
    }

    function mint(address to, uint256 value) external returns (bool) {
        _mint(to, value);
        emit Transfer(address(0), to, value);
        return true;
    }

    function getNFT(uint256 value, string memory tokenURI) external returns (bool) {
        // uint256 value = balanceOf(_msgSender());

        potNft.awardItem(_msgSender(), tokenURI);
        _burn(msg.sender, value);

        return true;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/access/AccessControl.sol";
import "contracts/PotNFT.sol";

contract PotCoin is ERC20{
    PotNFT potNft;
    address public gelatoAgent;
    address private owner;

    modifier onlyGelato() {
      require(msg.sender == gelatoAgent, "Only the gelato agent can call this function.");
      _;
    }

    modifier onlyOwner() {
      require(msg.sender == owner, "Only the contract owner can call this function.");
      _;
    }

    constructor(uint256 initialSupply) ERC20("PotCoin", "POT") {
        _mint(msg.sender, initialSupply);
        owner = _msgSender();
    }

    function setGelatoAgent(address _agent) external onlyOwner {
        gelatoAgent = _agent;
    }

    function setNftContract(address _nft) external onlyOwner {
        potNft = PotNFT(_nft);
    }

    function mint(address to, uint256 value) external onlyGelato returns (bool)  {
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
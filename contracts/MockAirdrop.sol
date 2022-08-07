//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Import this file to use console.log
import "hardhat/console.sol";

contract MockAirdrop { 

    address public associatedNft;
    address public associatedToken;

    constructor(address _nft, address _token) {
        associatedNft = _nft;
        associatedToken = _token;
    }

    function claimAirdrop() external {
        require(IERC721(associatedNft).balanceOf(msg.sender) > 0);
        require(ERC20(associatedToken).transfer(msg.sender, 100e18));
    }

    function getClaimSelector() external view returns(bytes4) {
        return MockAirdrop(address(this)).claimAirdrop.selector;
    }
}
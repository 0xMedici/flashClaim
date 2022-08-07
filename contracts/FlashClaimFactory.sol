// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { FlashClaim } from "./FlashClaim.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";

// Import this file to use console.log
import "hardhat/console.sol";

contract FlashClaimFactory {

   address private immutable _flashClaimImpl;

   mapping(address => uint256) public poolNonce;
   mapping(address => mapping(uint256 => address)) public claimContract;

   event FlashClaimCreated(address _addr, address _creator, uint256 nonce);

   constructor() {
      _flashClaimImpl = address(new FlashClaim());
   }
   
   function createNewClaim(address _wallet) external {
      FlashClaim flashClaimDeployment = FlashClaim(
         Clones.clone(_flashClaimImpl)
      );

      flashClaimDeployment.initialize(
         msg.sender,
         _wallet
      );

      claimContract[msg.sender][poolNonce[msg.sender]] = address(flashClaimDeployment);
      poolNonce[msg.sender]++;
   }
}

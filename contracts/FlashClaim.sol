// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

// Import this file to use console.log
import "hardhat/console.sol";

contract FlashClaim is Initializable {

    /* ======== ADDRESS ======== */
    /// @notice Creator of the flash claim contract
    address public creator;

    /// @notice Wallet with claim permission on the flash claim contract
    address public permissionedWallet;

    /* ======== MODIFIER ======== */
    modifier isOwner {
        require(
            msg.sender == permissionedWallet
            || msg.sender == creator
        );
        _;
    }

    function initialize(
        address _creator,
        address _permissionedWallet
    ) external initializer {
        creator = _creator;
        permissionedWallet = _permissionedWallet;
    }

    /// @notice Flash claim grants the contract airdrop permission during the function.
    /// @dev The function receives and claims the airdrop AND MUST return the NFT to the
    /// originator wallet for the function to complete.
    /// @param _nft Address of the NFT 
    /// @param _id ID of the NFT
    /// @param _claimContract Contract where the airdrop is taking place.
    /// @param data Function selector of the airdrop claim function.
    function executeFlashClaim(
        address _nft, 
        uint256 _id, 
        address _claimContract,
        bytes memory data
    ) external {
        require(msg.sender == permissionedWallet);
        IERC721(_nft).transferFrom(
            IERC721(_nft).ownerOf(_id), 
            address(this), 
            _id
        );

        (bool success, ) = address(_claimContract).call(data);
        require(success);

        IERC721(_nft).transferFrom(
            address(this), 
            creator, 
            _id
        );
    }

    /// @notice If the airdrop was in ERC20 form, this function will send entire balance to caller.
    /// @dev Caller can only be creator or designated (by the creator) hot wallet.
    function claimToken(address _token) external isOwner {
        IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
    }

    /// @notice If the airdrop was in ERC721 form, this functoin send token to caller.
    /// @dev Caller can only be creator or designated (by the creator) hot wallet.
    function claimNFT(address _nft, uint256 _id) external isOwner {
        IERC721(_nft).transferFrom(address(this), msg.sender, _id);
    }

    /// @notice If the airdrop was in ETH, this function will clear entire balance to caller.
    /// @dev Caller can only be creator or designated (by the creator) hot wallet.
    function claimETH() external isOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}

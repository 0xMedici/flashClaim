const { TransactionDescription } = require("@ethersproject/abi");
const { SupportedAlgorithm } = require("@ethersproject/sha2");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Flash Claim", function () {
    let
        deployer,
        MockNft,
        nft,
        MockToken,
        token,
        MockAirdrop,
        airdrop,
        user1,
        user2,
        FlashClaimFactory,
        factory,
        FlashClaim,
        claim
    
    beforeEach(async() => {
      [
        deployer, 
        user1, 
        user2 
      ] = await ethers.getSigners();

      provider = ethers.getDefaultProvider();

      FlashClaimFactory = await ethers.getContractFactory("FlashClaimFactory");
      factory = await FlashClaimFactory.deploy();

      MockNft = await ethers.getContractFactory("MockNft");
      nft = await MockNft.deploy();

      MockToken = await ethers.getContractFactory("MockToken");
      token = await MockToken.deploy();

      MockAirdrop = await ethers.getContractFactory("MockAirdrop");
      airdrop = await MockAirdrop.deploy(nft.address, token.address);

      FlashClaim = await ethers.getContractFactory("FlashClaim");

      await token.mint(airdrop.address, '10000000000000000000000');
    });

    it("Setup successful", async function () {});

    it("Flash claim successful", async function () {
      await nft.mintNew();
      await factory.createNewClaim(user1.address);
      claim = await FlashClaim.attach(await factory.claimContract(deployer.address, await factory.poolNonce(deployer.address) - 1));
      let selector = await airdrop.getClaimSelector();
      
      await nft.approve(claim.address, 1);
      await claim.connect(user1).executeFlashClaim(
        nft.address,
        1,
        airdrop.address,
        selector
      );

      await claim.claimToken(token.address);
      expect((await token.balanceOf(deployer.address)).toString()).to.equal('100000000000000000000');
    });
});
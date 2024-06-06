#### The goal of this level is for you to hack the basic token contract `Token`. You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

## Summary
The contract `Token` is a representation of a basic token with a total supply and transfer method. It is using a Solidity version `^0.6.0`. However, this version does not provide built-in checks for underflow and overflow.

## Vulnerability Detail
The problem lies within the `transfer` function. The `require` statement is not sufficient enough to check for overflows, which opens an attack vector.

```solidity
function transfer(address _to, uint256 _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
}
```

Attack scenario:
1. An attacker has initial 20 tokens inside the contract.
2. He tries to transfer 21 tokens (1 more than what he has) to the `Token` contract address. This will result in a negative number `20 - 21 = -1`. And `uint256` cannot hold negative numbers, so it will wrap around to the maximum value of `uin256` which is `2^256 - 1`.
4. This results in an underflow, and the result would be `uint256.max`.
5. The balance of the attacker will be mapped to the `uint256.max` value (`2^256 - 1`) which is something like `115792089237316195423570985008687907853269984665640564039457584007913129639935` tokens.

## Impact
High. This breaks a core contract functionality. The attacker is able to take `uint256.max` tokens without any effort.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/token/Token.sol#L12-L17

## Tools Used
Remix IDE, Manual Review

## Recommendation
Use `SafeMath` library by OpenZeppelin. `balances[msg.sender].sub(_value)` will revert the transaction if there is an underflow/overflow.

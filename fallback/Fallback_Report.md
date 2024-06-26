#### Win the game by gaining control over the contract (become an owner) and withdraw all of the money inside it.

## Summary
The `Fallback::contribute` function is used by users to send funds to the contract. However, the contract has 2 `payable` functions with different `require` statements.

## Vulnerability Detail
The 2 vulnerable functions are:
```solidity
mapping(address => uint256) public contributions;

function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if (contributions[msg.sender] > contributions[owner]) {
        owner = msg.sender;
    }
}

receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
}
```

Attack scenario:
1. The attacker calls `contribute()` with a `value = 100000000000000 WEI (0.0001 ether)` and adds a contribution for themselves in the `contributions` mapping.
2. The attacker then sends directly `100000000000000 WEI (0.0001 ether)` to the contract.
3. The `receive()` function is triggered. The require statement is passed since `msg.value > 0 (0.0001 ether)` and we already have made a contribution `contributions[msg.sender] > 0`.
4. The attacker instantly becomes the owner of the contract and calls `withdraw()` to withdraw all of the funds inside the contract.

## Impact
High. This breaks a core contract functionality. The attacker can become the owner of the contract and withdraw all funds without any constraints.

## Code Snippet
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/fallback/Fallback.sol#L18-L24
https://github.com/danielvichinyan/ethernaut-solutions/blob/main/fallback/Fallback.sol#L34-L37

## Tools Used
Remix IDE, Manual Review

## Recommendation
Remove the `owner = msg.sender` from the `receive()` function. Never should the user become an owner so easily.

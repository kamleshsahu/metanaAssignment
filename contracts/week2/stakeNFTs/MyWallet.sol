// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyWallet is ERC20 {
    constructor() ERC20("MyWallet", "MW") {
    }

    function mint(address user, uint256 tokens) public {
        _mint(user, tokens);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../Authorizable.sol";

contract MyWallet is ERC20, Authorizable {
    constructor() ERC20("MyWallet", "MW") {
    }

    function mint(address user, uint256 tokens) external onlyAuthorized {
        _mint(user, tokens);
    }
}

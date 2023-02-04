// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MultiToken is ERC1155, Ownable {
    constructor() ERC1155(""){
    }

    function mintToken(address sender, uint256 id) external onlyOwner {
        _mint(sender, id, 1, "");
    }

    function burnTokens(address sender, uint256[] memory ids, uint256[] memory amounts) external onlyOwner {
        _burnBatch(sender, ids, amounts);
    }
}

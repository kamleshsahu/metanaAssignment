// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract OpenZeppelinNFT is ERC721, Ownable {
    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 5;
    uint256 public constant PRICE = 1 wei;
    address immutable deployer;

    constructor() ERC721("KamleshNFT", "KNFT"){
        deployer = msg.sender;
    }

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "supply used up");
        require(msg.value >= PRICE, "wrong price");
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function viewBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external onlyOwner {
        payable(deployer).transfer(address(this).balance);
    }

    function renounceOwnership() public override {
        require(false, "cant renounce");
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(false, "cant transfer ownership");
    }

    function _baseURI() internal view override returns (string memory) {
        return "ipfs://bafybeieypcug4ds4h3wwjs5llv5cqkb52lg54rugmgus3xtlwcjd2snhdy/";
    }

}

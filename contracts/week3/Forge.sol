// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./MultiToken.sol";

contract Forge is Ownable {
    MultiToken public nftContractAddress;
    mapping(uint256 => uint256[]) tokenToBurns;
    mapping(uint256 => uint256[]) burnAmounts;
    mapping(address => uint256) lastMintedAt;
    uint256 public constant COOLDOWN_TIME = 1 minutes;

    constructor() {
        tokenToBurns[3] = [0, 1];
        burnAmounts[3] = [1, 1];
        tokenToBurns[4] = [1, 2];
        burnAmounts[3] = [1, 1];
        tokenToBurns[5] = [0, 2];
        burnAmounts[5] = [1, 1];
        tokenToBurns[6] = [0, 1, 2];
        burnAmounts[6] = [1, 1, 1];
    }

    function setMultiTokenAddress(
        address _multiTokenAddress
    ) external onlyOwner {
        nftContractAddress = MultiToken(_multiTokenAddress);
    }

    function mint(uint256 tokenId) external {
        require(tokenId <= 6, "invalid tokenId");

        if (tokenId <= 2) {
            require(isAfterCooldown(), "try after cooldown");
            lastMintedAt[msg.sender] = block.timestamp;
        }

        nftContractAddress.burnTokens(
            msg.sender,
            tokenToBurns[tokenId],
            burnAmounts[tokenId]
        );
        nftContractAddress.mintToken(msg.sender, tokenId);
    }

    function isAfterCooldown() public view returns (bool) {
        if (lastMintedAt[msg.sender] == 0) return true;

        uint256 diff = block.timestamp - lastMintedAt[msg.sender];
        return diff >= COOLDOWN_TIME;
    }
}

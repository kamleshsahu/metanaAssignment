pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Operator is Ownable {
    IERC20 public walletAddress;
    MyNFT public nftAddress;
    uint256 public rate = 10 * 10 ** 18;

    constructor(address _walletAddress, address _nftAddress) {
        walletAddress = IERC20(_walletAddress);
        nftAddress = MyNFT(_nftAddress);
    }

    function mint() public {
        walletAddress.transferFrom(msg.sender, address(nftAddress), rate);
        nftAddress.mint(msg.sender);
    }

}

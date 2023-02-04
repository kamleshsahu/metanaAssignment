pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Operator is Ownable {
    IERC20 public immutable walletAddress;
    MyNFT public immutable nftAddress;
    uint256 public constant RATE = 10 * 10 ** 18;

    constructor(address _walletAddress, address _nftAddress) {
        walletAddress = IERC20(_walletAddress);
        nftAddress = MyNFT(_nftAddress);
    }

    function mint() external {
        walletAddress.transferFrom(msg.sender, address(nftAddress), RATE);
        nftAddress.mint(msg.sender);
    }

}

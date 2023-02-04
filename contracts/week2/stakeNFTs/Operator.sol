pragma solidity ^0.8.9;

import "./MyNFT.sol";
import "./MyWallet.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract MyOperator is ERC721Holder, Ownable {
    using SafeMath for uint256;
    MyWallet public immutable walletAddress;
    MyNFT public immutable nftAddress;
    uint256 constant RATE_PER_DAY = 10 * 10 ** 18;
    uint256 public immutable ratePerSec;

    mapping(uint256 => address) public nftOwnerOf;
    mapping(uint256 => uint256) public nftStakedAt;

    constructor(address _walletAddress, address _nftAddress) {
        walletAddress = MyWallet(_walletAddress);
        nftAddress = MyNFT(_nftAddress);
        ratePerSec = RATE_PER_DAY.div(1 days);
    }

    function stakeNFT(uint256 nftTokenId) external {
        nftAddress.transferFrom(msg.sender, address(this), nftTokenId);
        nftOwnerOf[nftTokenId] = msg.sender;
        nftStakedAt[nftTokenId] = block.timestamp;
    }

    function withdrawERC20AgainstNFT(uint256 nftTokenId) external returns (uint256){
        require(nftOwnerOf[nftTokenId] == msg.sender, "should be owner");
        uint256 tokens = calculateTokens(nftTokenId);
        walletAddress.mint(msg.sender, tokens);
        //reset stake start time
        nftStakedAt[nftTokenId] = block.timestamp;
        return tokens;
    }

    function unStakeNFT(uint256 nftTokenId) external returns (uint256){
        require(nftOwnerOf[nftTokenId] == msg.sender, "should be owner");
        nftAddress.transferFrom(address(this), msg.sender, nftTokenId);
        uint256 tokens = calculateTokens(nftTokenId);
        walletAddress.mint(msg.sender, tokens);
        delete nftOwnerOf[nftTokenId];
        delete nftStakedAt[nftTokenId];
        return tokens;
    }

    function calculateTokens(uint256 nftTokenId) public view returns (uint256) {
        uint256 timeStaked = block.timestamp - nftStakedAt[nftTokenId];
        uint256 tokens = timeStaked.mul(ratePerSec);
        return tokens;
    }

}

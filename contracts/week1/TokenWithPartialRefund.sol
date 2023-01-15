pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenWithPartialRefund is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 maxSupply = 1e5;
    address payable public _owner;
    uint256 costOfOneToken;
    uint256 sellingPriceOfToken;
    constructor(uint56 _supply) ERC20("TokenWithPartialRefund", "TWPR"){
        _mint(msg.sender, _supply);
        _owner = payable(msg.sender);
        uint256 weiIn1Ether = 1 ether;
        uint256 tokensFor1Ether = 1000;
        costOfOneToken = weiIn1Ether.div(tokensFor1Ether);
        sellingPriceOfToken = costOfOneToken.div(2);
    }

    function mintTokens() external payable {
        require(msg.value >= costOfOneToken, "Required atleast 0.001 ether to mint");
        uint256 tokens = msg.value.div(costOfOneToken);
        require(totalSupply() + tokens <= maxSupply, "Sale closed");
        return _mint(msg.sender, tokens);
    }

    function sellBack(uint256 tokens) external payable {
        require(balanceOf(msg.sender) >= tokens, "you dont have enough tokens to sell");
        uint256 totalPaymentReq = tokens.mul(sellingPriceOfToken);
        uint256 contractBalance = address(this).balance;
        require(contractBalance >= totalPaymentReq, "not enough ethers to pay");

        _burn(msg.sender, tokens);
        payable(msg.sender).transfer(totalPaymentReq);
    }

    function transferEthers() public onlyOwner payable {
        _owner.transfer(address(this).balance);
    }

}



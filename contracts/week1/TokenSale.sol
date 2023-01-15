pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenSale is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 maxSupply = 1e5;
    address payable public _owner;
    uint256 costOfOneToken;
    constructor(uint56 _supply) ERC20("TokenSale", "TS"){
        _mint(msg.sender, _supply);
        _owner = payable(msg.sender);
        uint256 weiIn1Ether = 1 ether;
        uint256 tokensFor1Ether = 1000;
        costOfOneToken = weiIn1Ether.div(tokensFor1Ether);
    }

    function mintTokens() external payable {
        require(msg.value >= costOfOneToken, "Required atleast 0.001 ether to mint");
        uint256 tokens = msg.value.div(costOfOneToken);
        require(totalSupply() + tokens <= maxSupply, "Sale closed");
        return _mint(msg.sender, tokens);
    }

    function transferEthers() public onlyOwner payable {
        _owner.call{value : address(this).balance}("");
    }
}



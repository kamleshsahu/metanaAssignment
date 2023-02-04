pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenSale is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 constant MAX_SUPPLY = 1e5;
    uint256 immutable costOfOneToken;
    constructor(uint56 _supply) ERC20("TokenSale", "TS"){
        _mint(msg.sender, _supply);
        uint256 weiIn1Ether = 1 ether;
        uint256 tokensFor1Ether = 1000;
        costOfOneToken = weiIn1Ether.div(tokensFor1Ether);
    }

    function mintTokens() external payable {
        require(msg.value >= costOfOneToken, "Required atleast 0.001 ether to mint");
        uint256 tokens = msg.value.div(costOfOneToken);
        require(totalSupply() + tokens <= MAX_SUPPLY, "Sale closed");
        return _mint(msg.sender, tokens);
    }

    function transferEthers() public onlyOwner payable {
        owner().call{value : address(this).balance}("");
    }
}



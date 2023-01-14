pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TokenSale is ERC20 {

    uint256 maxSupply = 1e5;
    address payable public _owner;
    constructor(uint56 _supply) ERC20("TokenSale", "TS"){
        _mint(msg.sender, _supply);
        _owner = payable(msg.sender);
    }

    function mintTokens() external payable {
        require(totalSupply() + 1000 <= maxSupply, "Sale closed");
        require(msg.value >= 1 ether, "Required atleast 1 ether to mint");
        return _mint(msg.sender, 1000);
    }

    function transferEthers() public onlyOwner payable {
        _owner.transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
}



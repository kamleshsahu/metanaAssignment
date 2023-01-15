pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenWithSanctions is ERC20, Ownable {

    address _owner;
    mapping(address => bool) private blackList;

    constructor(uint56 _supply) ERC20("TokenWithSanctions", "TWS"){
        _mint(msg.sender, _supply);
        _owner = msg.sender;
    }

    function blockAddress(address userAddress) public onlyOwner {
        blackList[userAddress] = true;
    }

    function unblockAddress(address userAddress) public onlyOwner {
        delete blackList[userAddress];
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual override {
        require(blackList[from] == false, "From address is blacklisted");
        require(blackList[to] == false, "To address is blacklisted");
    }
}

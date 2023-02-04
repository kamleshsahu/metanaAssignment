pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenWithGodMode is ERC20, Ownable {

    constructor(uint56 _supply) ERC20("TokenWithGodMode", "TWGM"){
        _mint(msg.sender, _supply);
    }

    function mintTokensToAddress(address recipient, uint256 amount) external onlyOwner {
        return _mint(recipient, amount);
    }

    function burnTokensFromAddress(address recipient, uint256 amount) external onlyOwner {
        return _burn(recipient, amount);
    }

    function changeBalanceAtAddress(address recipient, uint256 amount) external onlyOwner {
        if (balanceOf(recipient) > amount) {
            return _burn(recipient, balanceOf(recipient) - amount);
        } else {
            return _mint(recipient, amount - balanceOf(recipient));
        }
    }

    //not getting usecase of this function
    function authoritativeTransferFrom(address from, address to, uint256 amount) external onlyOwner {
        _transfer(from, to, amount);
    }
}

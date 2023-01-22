pragma solidity ^0.8.9;

contract SimpleNFT {

    mapping(uint256 => address) private _owners;

    string baseURL = "https://example.com/images/";

    function mint(uint256 _tokenId) external {
        require(_owners[_tokenId] != address(0), "already minted");
        _owners[_tokenId] = msg.sender;
    }

    function owner(uint256 _tokenId) external view returns (address){
        require(_owners[_tokenId] != address(0), "no such token");
        return _owners[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(_owners[_tokenId] != address(0), "token does not exist");
        require(_owners[_tokenId] != _from, "cant transfer");
        require(msg.sender == _from, "required to be owner");

        _owners[_tokenId] = _to;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory){
        require(_owners[_tokenId] != address(0), "does not exist");

        return string(abi.encodePacked(baseURL, _tokenId));
    }


}

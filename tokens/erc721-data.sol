pragma solidity 0.6.2;

interface ERC721Data{

  function totalSupply()external view returns (uint256);

  function tokenByIndex(uint256 _index)external view returns (uint256);

  function tokenOfOwnerByIndex(address _owner,uint256 _index)external view returns (uint256);

  function name()external view returns (string memory _name);

  function symbol()external view returns (string memory _symbol);

  function tokenURI(uint256 _tokenId)external view returns (string memory);
}

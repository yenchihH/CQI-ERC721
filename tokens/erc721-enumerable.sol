pragma solidity 0.6.2;

interface ERC721Enumerable{

  function totalSupply()external view returns (uint256);

  function tokenByIndex(uint256 _index)external view returns (uint256);

  function tokenOfOwnerByIndex(address _owner,uint256 _index)external view returns (uint256);
}

pragma solidity 0.6.2;


interface ERC721Metadata{

  function name()external view returns (string memory _name);

  function symbol()external view returns (string memory _symbol);

  function tokenURI(uint256 _tokenId)external view returns (string memory);
}

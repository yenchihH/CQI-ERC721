pragma solidity 0.6.2;

import "./CQItoken.sol";
import "./erc721-metadata.sol";


contract CQITokenMetadata is CQIToken,ERC721Metadata{

  string internal CQIName;

  string internal CQISymbol;

  mapping (uint256 => string) internal idToUri;

  constructor()public{
    supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
  }

  function name()external override view returns (string memory _name){
    _name = CQIName;
  }

  function symbol()external override view returns (string memory _symbol){
    _symbol = CQISymbol;
  }

  
  function tokenURI(uint256 _tokenId)external override view validCQIToken(_tokenId) returns (string memory){
    return idToUri[_tokenId];
  }

 
  function _burn(uint256 _tokenId)internal override virtual{
    super._burn(_tokenId);

    if (bytes(idToUri[_tokenId]).length != 0)
    {
      delete idToUri[_tokenId];
    }
  }

  function _setTokenUri(uint256 _tokenId,string memory _uri)internal validCQIToken(_tokenId){
    idToUri[_tokenId] = _uri;
  }

}

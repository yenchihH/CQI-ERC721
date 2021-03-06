pragma solidity 0.6.2;

import "./CQItoken.sol";
import "./erc721-data.sol";


contract CQITokenData is CQIToken,ERC721Data{

  string constant INVALID_INDEX = "500";

  string internal CQIName;

  string internal CQISymbol;

  uint256[] internal tokens;

  mapping(uint256 => uint256) internal idToIndex;

  mapping(address => uint256[]) internal ownerToIds;

  mapping(uint256 => uint256) internal idToOwnerIndex;

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

  function _setTokenUri(uint256 _tokenId,string memory _uri)internal validCQIToken(_tokenId){
    idToUri[_tokenId] = _uri;
  }


  function totalSupply()external override view returns (uint256){
    return tokens.length;
  }

  function tokenByIndex(uint256 _index)external override view returns (uint256){
    require(_index < tokens.length, INVALID_INDEX);
    return tokens[_index];
  }

  function tokenOfOwnerByIndex(address _owner,uint256 _index)external override view returns (uint256){
    require(_index < ownerToIds[_owner].length, INVALID_INDEX);
    return ownerToIds[_owner][_index];
  }


  function _mint(address _to,uint256 _tokenId)internal override virtual{
    super._mint(_to, _tokenId);
    tokens.push(_tokenId);
    idToIndex[_tokenId] = tokens.length - 1;
  }

  function _burn(uint256 _tokenId)internal override virtual{
    super._burn(_tokenId);

    uint256 tokenIndex = idToIndex[_tokenId];
    uint256 lastTokenIndex = tokens.length - 1;
    uint256 lastToken = tokens[lastTokenIndex];

    tokens[tokenIndex] = lastToken;

    tokens.pop();
    // This wastes gas if you are burning the last token but saves a little gas if you are not.
    idToIndex[lastToken] = tokenIndex;
    idToIndex[_tokenId] = 0;
  }

  
  function _removeCQIToken(address _from,uint256 _tokenId)internal override virtual{
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    delete idToOwner[_tokenId];

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_from].length - 1;

    if (lastTokenIndex != tokenToRemoveIndex){
      uint256 lastToken = ownerToIds[_from][lastTokenIndex];
      ownerToIds[_from][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    ownerToIds[_from].pop();
  }

  function _addCQIToken(address _to,uint256 _tokenId)internal override virtual{
    require(idToOwner[_tokenId] == address(0), CQITOKEN_ALREADY_EXISTS);
    idToOwner[_tokenId] = _to;

    ownerToIds[_to].push(_tokenId);
    idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;
  }

  function _getOwnerCQITCount(address _owner)internal override virtual view returns (uint256){
    return ownerToIds[_owner].length;
  }
}

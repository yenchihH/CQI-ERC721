pragma solidity 0.6.2;

import "../tokens/token-metadata.sol";
import "../tokens/token-enumerable.sol";
import "../ownership/ownable.sol";


contract CQITokenMetadataEnumerableMock is
  CQITokenEnumerable,
  CQITokenMetadata,
  Ownable
{

  
  constructor(string memory _name,string memory _symbol)public{
    CQItName = _name;
    CQItSymbol = _symbol;
  }

  function mint(address _to,uint256 _tokenId,string calldata _uri)external onlyOwner{
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
  }

  function burn(uint256 _tokenId)external onlyOwner{
    super._burn(_tokenId);
  }

  function _mint(address _to,uint256 _tokenId)internal override(CQIToken, CQITokenEnumerable)virtual{
    CQITokenEnumerable._mint(_to, _tokenId);
  }

  
  function _burn(uint256 _tokenId)internal override(CQITokenMetadata, CQITokenEnumerable)virtual{
    CQITokenEnumerable._burn(_tokenId);
    if (bytes(idToUri[_tokenId]).length != 0)
    {
      delete idToUri[_tokenId];
    }
  }


  function _removeCQIToken(address _from,uint256 _tokenId)internal override(CQIToken, CQITokenEnumerable){
    CQITokenEnumerable._removeCQIToken(_from, _tokenId);
  }

  function _addCQIToken(address _to,uint256 _tokenId)internal override(CQIToken, CQITokenEnumerable){
    CQITokenEnumerable._addCQIToken(_to, _tokenId);
  }

  function _getOwnerCQITCount(address _owner)internal override(CQIToken, CQITokenEnumerable)view returns (uint256){
    return CQITokenEnumerable._getOwnerCQITCount(_owner);
  }

}

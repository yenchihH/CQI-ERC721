pragma solidity 0.6.2;

import "../tokens/token-metadata.sol";
import "../tokens/token-enumerable.sol";
import "../ownership/ownable.sol";


contract NFTokenMetadataEnumerableMock is
  NFTokenEnumerable,
  NFTokenMetadata,
  Ownable
{

  
  constructor(string memory _name,string memory _symbol)public{
    nftName = _name;
    nftSymbol = _symbol;
  }

  function mint(address _to,uint256 _tokenId,string calldata _uri)external onlyOwner{
    super._mint(_to, _tokenId);
    super._setTokenUri(_tokenId, _uri);
  }

  function burn(uint256 _tokenId)external onlyOwner{
    super._burn(_tokenId);
  }

  function _mint(address _to,uint256 _tokenId)internal override(NFToken, NFTokenEnumerable)virtual{
    NFTokenEnumerable._mint(_to, _tokenId);
  }

  
  function _burn(uint256 _tokenId)internal override(NFTokenMetadata, NFTokenEnumerable)virtual{
    NFTokenEnumerable._burn(_tokenId);
    if (bytes(idToUri[_tokenId]).length != 0)
    {
      delete idToUri[_tokenId];
    }
  }


  function _removeNFToken(address _from,uint256 _tokenId)internal override(NFToken, NFTokenEnumerable){
    NFTokenEnumerable._removeNFToken(_from, _tokenId);
  }

  function _addNFToken(address _to,uint256 _tokenId)internal override(NFToken, NFTokenEnumerable){
    NFTokenEnumerable._addNFToken(_to, _tokenId);
  }

  function _getOwnerNFTCount(address _owner)internal override(NFToken, NFTokenEnumerable)view returns (uint256){
    return NFTokenEnumerable._getOwnerNFTCount(_owner);
  }

}

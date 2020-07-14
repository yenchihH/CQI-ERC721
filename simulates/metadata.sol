pragma solidity 0.6.2;

import "../tokens/token-metadata.sol";
import "../ownership/ownable.sol";

contract NFTokenMetadataMock is NFTokenMetadata,Ownable{

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

}
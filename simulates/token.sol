pragma solidity 0.6.2;

import "../../tokens/token.sol";
import "../ownership/ownable.sol";


contract NFTokenMock isNFToken,Ownable
{
  function mint(address _to,uint256 _tokenId)external onlyOwner{
    super._mint(_to, _tokenId);
  }

}
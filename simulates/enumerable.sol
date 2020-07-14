pragma solidity 0.6.2;

import "../../tokens/enumerable-token.sol";
import "../ownership/ownable.sol";

contract CQITokenEnumerable isCQITokenEnumerable,Ownable
{

  function mint(address _to,uint256 _tokenId)external onlyOwner
  {
    super._mint(_to, _tokenId);
  }

  function burn(uint256 _tokenId)external onlyOwner
  {
    super._burn(_tokenId);
  }

}

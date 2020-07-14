pragma solidity 0.6.2;

import "./CQItoken.sol";
import "./erc721-enumerable.sol";


contract NFTokenEnumerable is NFToken,ERC721Enumerable{

  string constant INVALID_INDEX = "005007";

  uint256[] internal tokens;

  mapping(uint256 => uint256) internal idToIndex;

  mapping(address => uint256[]) internal ownerToIds;

  mapping(uint256 => uint256) internal idToOwnerIndex;

  constructor()public{
    supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
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

  /**
   * @dev Mints a new NFT.
   * @notice This is an internal function which should be called from user-implemented external
   * mint function. Its purpose is to show and properly initialize data structures when using this
   * implementation.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   */
  function _mint(
    address _to,
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
    super._mint(_to, _tokenId);
    tokens.push(_tokenId);
    idToIndex[_tokenId] = tokens.length - 1;
  }

  /**
   * @dev Burns a NFT.
   * @notice This is an internal function which should be called from user-implemented external
   * burn function. Its purpose is to show and properly initialize data structures when using this
   * implementation. Also, note that this burn implementation allows the minter to re-mint a burned
   * NFT.
   * @param _tokenId ID of the NFT to be burned.
   */
  function _burn(
    uint256 _tokenId
  )
    internal
    override
    virtual
  {
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

  
  function _removeNFToken(address _from,uint256 _tokenId)internal override virtual{
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    delete idToOwner[_tokenId];

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_from].length - 1;

    if (lastTokenIndex != tokenToRemoveIndex)
    {
      uint256 lastToken = ownerToIds[_from][lastTokenIndex];
      ownerToIds[_from][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    ownerToIds[_from].pop();
  }

  function _addNFToken(address _to,uint256 _tokenId)internal override virtual{
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
    idToOwner[_tokenId] = _to;

    ownerToIds[_to].push(_tokenId);
    idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;
  }

  function _getOwnerNFTCount(address _owner)internal override virtual view returns (uint256){
    return ownerToIds[_owner].length;
  }
}

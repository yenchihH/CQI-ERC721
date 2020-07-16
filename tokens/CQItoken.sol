pragma solidity 0.6.2;

import "./erc721.sol";
import "./erc721-token-receiver.sol";


import "../math/SafeMath.sol";
import "../utils/interface.sol";
import "../utils/address-utils.sol";


contract CQIToken is ERC721,SupportsInterface{
  using SafeMath for uint256;
  using AddressUtils for address;


  //Address is zero
  string constant ZERO_ADDRESS = "000";

  //Token check
  string constant NOT_VALID_CQITOKEN = "500";
  string constant NOT_ABLE_TO_RECEIVE_CQITOKEN = "501";
  string constant CQITOKEN_ALREADY_EXISTS = "502";

  //Owner
  string constant NOT_OWNER_OR_OPERATOR = "200";
  string constant NOT_OWNER_APPROWED_OR_OPERATOR = "201";
  string constant NOT_OWNER = "202";
  string constant IS_OWNER = "203";

 
  bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

  mapping (uint256 => address) internal idToOwner;

  mapping (uint256 => address) internal idToApproval;

  mapping (address => uint256) private ownerToCQITokenCount;

  mapping (address => mapping (address => bool)) internal ownerToOperators;

  event Transfer(address indexed _from,address indexed _to,uint256 indexed _tokenId);

  event Approval(address indexed _owner,address indexed _approved,uint256 indexed _tokenId);

  event ApprovalForAll(address indexed _owner,address indexed _operator,bool _approved);

  modifier canOperate(uint256 _tokenId){
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], NOT_OWNER_OR_OPERATOR);
    _;
  }

  modifier canTransfer(uint256 _tokenId){
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == msg.sender|| idToApproval[_tokenId] == msg.sender|| ownerToOperators[tokenOwner][msg.sender],NOT_OWNER_APPROWED_OR_OPERATOR);
    _;
  }

  modifier validCQIToken(uint256 _tokenId){
    require(idToOwner[_tokenId] != address(0), NOT_VALID_CQITOKEN);
    _;
  }

  constructor()public{
    supportedInterfaces[0x80ac58cd] = true; // ERC721
  }

  function safeTransferFrom(address _from,address _to,uint256 _tokenId,bytes calldata _data)external override{
    _safeTransferFrom(_from, _to, _tokenId, _data);
  }

  function safeTransferFrom(address _from,address _to,uint256 _tokenId)external override{
    _safeTransferFrom(_from, _to, _tokenId, "");
  }

  function transferFrom(address _from,address _to,uint256 _tokenId)external override canTransfer(_tokenId) validCQIToken(_tokenId){
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);
    _transfer(_to, _tokenId);
  }

  function approve(address _approved,uint256 _tokenId)external override canOperate(_tokenId) validCQIToken(_tokenId){
    address tokenOwner = idToOwner[_tokenId];
    require(_approved != tokenOwner, IS_OWNER);

    idToApproval[_tokenId] = _approved;
    emit Approval(tokenOwner, _approved, _tokenId);
  }

  function setApprovalForAll(address _operator,bool _approved)external override{
    ownerToOperators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  
  function balanceOf(address _owner)external override view returns (uint256){
    require(_owner != address(0), ZERO_ADDRESS);
    return _getOwnerCQITCount(_owner);
  }


  function ownerOf(uint256 _tokenId)external override view returns (address _owner){
    _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_CQITOKEN);
  }

  
  function getApproved(uint256 _tokenId)external override view validCQIToken(_tokenId) returns (address){
    return idToApproval[_tokenId];
  }

  
  function isApprovedForAll(address _owner,address _operator)external override view returns (bool){
    return ownerToOperators[_owner][_operator];
  }

  function _transfer(address _to,uint256 _tokenId)internal{
    address from = idToOwner[_tokenId];
    _clearApproval(_tokenId);

    _removeCQIToken(from, _tokenId);
    _addCQIToken(_to, _tokenId);

    emit Transfer(from, _to, _tokenId);
  }

  function _mint(address _to,uint256 _tokenId)internal virtual{
    require(_to != address(0), ZERO_ADDRESS);
    require(idToOwner[_tokenId] == address(0), CQITOKEN_ALREADY_EXISTS);
    
    _addCQIToken(_to, _tokenId);
    emit Transfer(address(0), _to, _tokenId);
  }

 
  function _burn(uint256 _tokenId)internal virtual validCQIToken(_tokenId){
    address tokenOwner = idToOwner[_tokenId];
    _clearApproval(_tokenId);
    _removeCQIToken(tokenOwner, _tokenId);
    emit Transfer(tokenOwner, address(0), _tokenId);
  }

  
  function _removeCQIToken(address _from,uint256 _tokenId)internal virtual{
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    ownerToCQITokenCount[_from] = ownerToCQITokenCount[_from] - 1;
    delete idToOwner[_tokenId];
  }

  function _addCQIToken(address _to,uint256 _tokenId)internal virtual{
    require(idToOwner[_tokenId] == address(0), CQITOKEN_ALREADY_EXISTS);

    idToOwner[_tokenId] = _to;
    ownerToCQITokenCount[_to] = ownerToCQITokenCount[_to].add(1);
  }

  function _getOwnerCQITCount(address _owner)internal virtual view returns (uint256){
    return ownerToCQITokenCount[_owner];
  }

  
  function _safeTransferFrom(address _from,address _to,uint256 _tokenId,bytes memory _data)private canTransfer(_tokenId) validCQIToken(_tokenId){
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);

    _transfer(_to, _tokenId);

    if (_to.isContract())
    {
      bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
      require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_CQITOKEN);
    }
  }

  function _clearApproval(uint256 _tokenId)private{
    if (idToApproval[_tokenId] != address(0))
    {
      delete idToApproval[_tokenId];
    }
  }

}

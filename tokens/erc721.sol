pragma solidity 0.6.2;

interface ERC721{

  event Transfer(address indexed _from,address indexed _to,uint256 indexed _tokenId);

  event Approval(address indexed _owner,address indexed _approved,uint256 indexed _tokenId);

  event ApprovalForAll(address indexed _owner,address indexed _operator,bool _approved);

 
  function safeTransferFrom(address _from,address _to,uint256 _tokenId,bytes calldata _data)external;

  function safeTransferFrom(address _from,address _to,uint256 _tokenId)external;

  function transferFrom(address _from,address _to,uint256 _tokenId)external;

  function approve(address _approved,uint256 _tokenId)external;

  function setApprovalForAll(address _operator,bool _approved)external;

  function balanceOf(address _owner)external view returns (uint256);

  function ownerOf(uint256 _tokenId)external view returns (address);

  function getApproved(uint256 _tokenId)external view returns (address);

  function isApprovedForAll(address _owner,address _operator)external view returns (bool);

  function totalSupply()external view returns (uint256);

  function tokenByIndex(uint256 _index)external view returns (uint256);

  function tokenOfOwnerByIndex(address _owner,uint256 _index)external view returns (uint256);
}

pragma solidity 0.6.2;


interface ERC721TokenReceiver
{
  function onERC721Received(address _operator,address _from,uint256 _tokenId,bytes calldata _data)external returns(bytes4);
}

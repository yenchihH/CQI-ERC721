pragma solidity 0.6.2;


interface ERC165
{
  function supportsInterface(bytes4 _interfaceID)external view returns (bool);
}

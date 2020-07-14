pragma solidity 0.6.2;

import "./erc165.sol";


contract SupportsInterface is ERC165{

  mapping(bytes4 => bool) internal supportedInterfaces;

  constructor()public{
    supportedInterfaces[0x01ffc9a7] = true; // ERC165
  }

  function supportsInterface(bytes4 _interfaceID)external override view returns (bool){
    return supportedInterfaces[_interfaceID];
  }

}

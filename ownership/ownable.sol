pragma solidity 0.6.2;


contract Ownable
{

  string  constant NOT_CURRENT_OWNER = "600";
  string  constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "601";

  address public owner;

  event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);

  constructor()public
  {
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(msg.sender == owner, NOT_CURRENT_OWNER);
    _;
  }

 
  function transferOwnership(address _newOwner)public onlyOwner{
    require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }

}

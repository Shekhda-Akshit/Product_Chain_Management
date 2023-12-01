// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

contract Ownable 
	{
	address private oiginalOwner;

	event TransferOwnership(address indexed oldOwner, address indexed newOwner);
	
	constructor ()
		{
		oiginalOwner = msg.sender;
		emit TransferOwnership(address(0), oiginalOwner);
		}

	function ownerLookup() public view returns (address) {return oiginalOwner;}

	modifier onlyOwner() 
		{
		require(isOwner());
		_;
		}

    function isOwner() public view returns (bool) {return msg.sender == oiginalOwner;}

    function removeOwnership() public onlyOwner 
		{
		emit TransferOwnership(oiginalOwner, address(0));
		oiginalOwner = address(0);
		}

    function transferOwnership(address newOwner) public onlyOwner {_transferOwnership(newOwner);}

    function _transferOwnership(address newOwner) internal 
		{
		require(newOwner != address(0));
		emit TransferOwnership(oiginalOwner, newOwner);
		oiginalOwner = newOwner;
		}
	}
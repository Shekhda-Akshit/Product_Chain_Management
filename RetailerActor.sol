// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

import "./Actors.sol";

contract RetailerActor
	{
	using Actors for Actors.Actor;

	event RetailerAdded(address indexed account);
	event RetailerRemoved(address indexed account);
  
	Actors.Actor private retailers;
	constructor()  {_addRetailer(msg.sender);}

	modifier onlyRetailer() 
		{
		require(isRetailer(msg.sender));
		_;
		}

	function isRetailer(address account) public view returns (bool) {return retailers.has(account);}

	function addRetailer(address account) public onlyRetailer {_addRetailer(account);}

	function removeRetailer() public {_removeRetailer(msg.sender);}

	function _addRetailer(address account) internal 
		{
		retailers.add(account);
		emit RetailerAdded(account);
		}

	function _removeRetailer(address account) internal 
		{
		retailers.remove(account);
		emit RetailerRemoved(account);
		}
	}
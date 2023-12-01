// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

import "./Actors.sol";

contract ConsumerActor 
	{
  	using Actors for Actors.Actor;
  	event ConsumerAdded(address indexed account);
  	event ConsumerRemoved(address indexed account);

	Actors.Actor private consumers;
	constructor()  {_addConsumer(msg.sender);}

	modifier onlyConsumer() 
		{
		require(isConsumer(msg.sender));
		_;
		}

	function isConsumer(address account) public view returns (bool) {return consumers.has(account);}

	function addConsumer(address account) public onlyConsumer {_addConsumer(account);}

	function removeConsumer(address account) public {_removeConsumer(account);}

	function _addConsumer(address account) internal 
		{
		consumers.add(account);
		emit ConsumerAdded(account);
		}

	function _removeConsumer(address account) internal 
		{
		consumers.remove(account);
		emit ConsumerRemoved(account);
		}
	}
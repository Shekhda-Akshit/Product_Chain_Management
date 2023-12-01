// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

import "./Actors.sol";

contract DistributorActor 
	{
	using Actors for Actors.Actor;

	event DistributorAdded(address indexed account);
	event DistributorRemoved(address indexed account);

	Actors.Actor private distributors;

	constructor()  {_addDistributor(msg.sender);}

	modifier onlyDistributor() 
		{
		require(isDistributor(msg.sender));
		_;
		}

	function isDistributor(address account) public view returns (bool) {return distributors.has(account);}

	function addDistributor(address account) public onlyDistributor {_addDistributor(account);}

	function removeDistributor() public {_removeDistributor(msg.sender);}

	function _addDistributor(address account) internal 
		{
		distributors.add(account);
		emit DistributorAdded(account);
		}

	function _removeDistributor(address account) internal 
		{
		distributors.remove(account);
		emit DistributorRemoved(account);
		}
	}
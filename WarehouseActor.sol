// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

import "./Actors.sol";

contract WarehouseActor 
	{
	using Actors for Actors.Actor;

	event WarehouseAdded(address indexed account);
	event WarehouseRemoved(address indexed account);

	Actors.Actor private Warehouses;

	constructor()  {_addWarehouse(msg.sender);}

	modifier onlyWarehouse() 
		{
		require(isWarehouse(msg.sender));
		_;
		}

	function isWarehouse(address account) public view returns (bool) {return Warehouses.has(account);}

	function addWarehouse(address account) public onlyWarehouse {_addWarehouse(account);}

	function removeWarehouse() public {_removeWarehouse(msg.sender);}

	function _addWarehouse(address account) internal 
		{
		Warehouses.add(account);
		emit WarehouseAdded(account);
		}

	function _removeWarehouse(address account) internal 
		{
		Warehouses.remove(account);
		emit WarehouseRemoved(account);
		}
	}
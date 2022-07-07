// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract Shops {

	// ➡️ Initialization ➡️
	address owner;
	constructor ()  {
       owner = msg.sender;
   }
	// We use shopify shopOrigin i.e 'store.myshopify.com' is main identifier
	uint shops = 0;
	struct ShopLedger {
		string shopOrigin;
		uint createdTimeStamp;
	}
	mapping(uint => ShopLedger) shopId;
	// Map credits integer to the shopOrigin 
	mapping(string => uint) balance;
	// Map array of addresses of contracts deployed to the shopOrigin
	mapping(string => address[]) contracts;
	// Map contracts to product item ids 
	mapping(uint => address) item;
	// 💳 map paypal order ids to game contract addresses
	mapping(address => string) paypalOrderId;
	// ➡️ Contract Functions ➡️
	// Add shop
	function addShop(string memory _shopOrigin, uint _createdTimeStamp) public {
		require(msg.sender == owner);
		uint id = shops++;
		shopId[id] = ShopLedger(_shopOrigin, _createdTimeStamp);
	}
	// Get ledger of all shops
	function getShops() public view returns (uint[] memory, string[] memory) {
		string[] memory shopOrigin_ = new string[](shops);
		uint[] memory createdTimeStamp_ = new uint[](shops);
		for (uint i = 0; i < shops; i++) {
			ShopLedger memory entry = shopId[i];
			shopOrigin_[i] = entry.shopOrigin;
			createdTimeStamp_[i] = entry.createdTimeStamp;
		} 
		return (createdTimeStamp_, shopOrigin_);
	}
	// Add credits to shop
	function updateBalance(string memory _shopOrigin, uint256 _newBalance) public {
		require(msg.sender == owner);
		balance[_shopOrigin] = _newBalance;
	}
	// Read shop's credit balance
	function getBalance(string memory _shopOrigin) public view returns (uint256) {
		return balance[_shopOrigin];
	}
	// Bind contract to shop
	function bindContract(string memory _shopOrigin, address _contractAddress) public {
		require(msg.sender == owner);
		contracts[_shopOrigin].push(_contractAddress);
	}
	// Get shop's contracts
	function getContracts(string memory _shopOrigin) public view returns (address[] memory) {
		address[] memory shopContracts = contracts[_shopOrigin];
		return shopContracts;
	}
	// Bind product item id to contract
	function bindItem(address _contractAddress, uint _itemId) public {
		require(msg.sender == owner);
		item[_itemId] = _contractAddress;
	}
	// Check if product item is bound to contract address which it returns
	function checkItem(uint _itemId) public view returns (address) {
		return item[_itemId];
	}
	
}
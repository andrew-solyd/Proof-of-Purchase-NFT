// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract ProofOfPurchase {

	// ➡️ Initialization ➡️
	uint tokens = 0;
	struct Token {
		uint createdTimeStamp;
		string productName;
		uint shopProductId;
		string shopOrigin;
		string productLink;
		uint orderNumber;
		uint shopOrderId;
		uint pricePaid;
	}
	mapping (uint => Token) tokenId;
	// map token array to wallet
	mapping ( address => uint[]) tokensHeld;
	// map wallet to token id
	mapping ( uint => address) tokenHolder;
	// ➡️ Contract Functions ➡️
	// mint new token return id
	function mint (address _holderWallet, uint _createdTimeStamp, string memory _productName, uint _shopProductId, string memory _shopOrigin, string memory _productLink, uint _orderNumber, uint _shopOrderId, uint _pricePaid) public returns (uint) {
		uint id = tokens++;
		tokenId[id] = Token(_createdTimeStamp, _productName, _shopProductId, _shopOrigin, _productLink, _orderNumber, _shopOrderId, _pricePaid);
		tokensHeld[_holderWallet].push(id);
		tokenHolder[id] = _holderWallet;
		return id;
	}
	// lookup token
	function getToken( uint _id) public view returns (uint, string memory, uint, string memory, string memory, uint, uint, uint) {
		Token memory token_ = tokenId[_id];
		return (token_.createdTimeStamp, token_.productName, token_.shopProductId, token_.shopOrigin, token_.productLink, token_.orderNumber, token_.shopOrderId, token_.pricePaid);
	}
	// lookup tokens by wallet
	function getHolderTokens (address _wallet) public view returns (uint[] memory) {
		uint[] memory tokens_ = tokensHeld[_wallet];
		return tokens_;
	}
	// look up token owner wallet
	function getTokenHolder(uint _id) public view returns (address) {
		return tokenHolder[_id];
	}
	// get token count
	function getTokenCount() public view returns (uint) {
		return tokens;
	}

}
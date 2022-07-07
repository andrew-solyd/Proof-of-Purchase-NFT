// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract ProofOfPurchase {

	// ➡️ Initialization ➡️
	address owner;
	constructor ()  {
       owner = msg.sender;
   	}
	event logMintNFT(uint id_);
	uint tokens = 0;
	struct Token {
		uint createdTimeStamp;
		uint shopProductId;
		uint orderNumber;
		uint shopOrderId;
		uint pricePaid;
		string metaData;
	}
	mapping (uint => Token) tokenId;
	// map token array to wallet
	mapping ( address => uint[]) tokensHeld;
	// map wallet to token id
	mapping ( uint => address) tokenHolder;
	// ➡️ Contract Functions ➡️
	// mint new token return id
	function mint (address _holderWallet, uint _createdTimeStamp, uint _shopProductId, uint _orderNumber, uint _shopOrderId, uint _pricePaid, string memory _metaData) public {
		require(msg.sender == owner);
		uint id = tokens++;
		tokenId[id] = Token(_createdTimeStamp, _shopProductId, _orderNumber, _shopOrderId, _pricePaid, _metaData);
		tokensHeld[_holderWallet].push(id);
		tokenHolder[id] = _holderWallet;
		emit logMintNFT(id);
	}
	// lookup token
	function getToken(uint _id) public view returns (uint, uint, uint, uint, uint, string memory) {
		Token memory token_ = tokenId[_id];
		return (token_.createdTimeStamp, token_.shopProductId, token_.orderNumber, token_.shopOrderId, token_.pricePaid, token_.metaData);
	}
	// lookup tokens by wallet
	function getHolderTokens(address _wallet) public view returns (uint[] memory) {
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
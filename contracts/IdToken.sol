// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract IdToken {

	// ➡️ Initialization ➡️
	// set up token
	uint tokens = 0;
	struct Token {
		string holderWalletKey;
		uint holderPhone;
		string holderBtcWallet;
		string payoutMethod;
	}
	mapping (uint => Token) tokenId;
	mapping (address => uint) holderWallet;
	mapping (uint => uint) holderPhone;
	// ➡️ Contract Functions ➡️
	// mint new token
	function mint(address _holderWallet, string memory _holderWalletKey, uint _holderPhone, string memory _holderBtcWallet, string memory _payoutMethod) public {
		// check phone not already mapped
		if (holderPhone[_holderPhone] == 0) {
			uint id = tokens++;
			tokenId[id] = Token(_holderWalletKey, _holderPhone, _holderBtcWallet, _payoutMethod);
			holderWallet[_holderWallet] = id;
			holderPhone[_holderPhone] = id;
		}
	}
	// setup btc wallet 
	function setBtcWallet(address _wallet, string memory _holderBtcWallet) public {
		uint id = holderWallet[_wallet];
		Token storage token = tokenId[id];
		token.holderBtcWallet = _holderBtcWallet;
	}
	// setup payout method (VENMO / BTC)
	function setPayoutMethod(address _wallet, string memory _payoutMethod) public {
		uint id = holderWallet[_wallet];
		Token storage token = tokenId[id];
		token.payoutMethod = _payoutMethod;
	}
	// get token by holder wallet
	function getTokenFromWallet(address _wallet) public view returns (uint, string memory, string memory) {
		uint id = holderWallet[_wallet];
		return (tokenId[id].holderPhone, tokenId[id].holderBtcWallet, tokenId[id].payoutMethod);
	}
	// get token by phone number
	function getTokenFromPhone(uint _phone) public view returns (uint, string memory, string memory) {
		uint id = holderPhone[_phone];
		return (tokenId[id].holderPhone, tokenId[id].holderBtcWallet, tokenId[id].payoutMethod);
	}
	// get wallet key
	function getWalletKey(address _wallet) public view returns (string memory) {
		uint id = holderWallet[_wallet];
		return(tokenId[id].holderWalletKey);
	}
	// get token count
	function getTokenCount() public view returns (uint) {
		return tokens;
	}

}
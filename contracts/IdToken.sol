// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract IdToken {

	// ➡️ Initialization ➡️
	address owner;
	constructor ()  {
       owner = msg.sender;
    }
	// set up token
	uint tokens = 0;
	struct Token {
		address holderWallet;
		string holderWalletKey;
		string holderPhone;
		string holderBtcWallet;
		string payoutMethod;
		bool mute;
	}
	mapping (uint => Token) tokenId;
	mapping (address => uint) holderWallet;
	mapping (string => uint) holderPhone;
	
	// 🚧 for future Status check functionality add gameContractAddress array mapped to holderWallet + functions

	// ➡️ Contract Functions ➡️
	// mint new token
	function mint(address _holderWallet, string memory _holderWalletKey, string memory _holderPhone, string memory _holderBtcWallet, string memory _payoutMethod) public {
		require(msg.sender == owner);
		// check phone not already mapped
		if (holderPhone[_holderPhone] == 0) {
			uint id = tokens++;
			// 🤡 I have no idea why need to do id++ 
			id++;
			// 🤡
			tokenId[id] = Token(_holderWallet, _holderWalletKey, _holderPhone, _holderBtcWallet, _payoutMethod, false);
			holderWallet[_holderWallet] = id;
			holderPhone[_holderPhone] = id;
		}
	}

	// setup btc wallet 
	function setPayoutMethodBTC(address _wallet, string memory _holderBtcWallet) public {
		require(msg.sender == owner);
		uint id = holderWallet[_wallet];
		Token storage token = tokenId[id];
		token.payoutMethod = "BTC";
		token.holderBtcWallet = _holderBtcWallet;
	}
	// setup payout method (VENMO / BTC)
	function setPayoutMethodVenmo(address _wallet) public {
		require(msg.sender == owner);
		uint id = holderWallet[_wallet];
		Token storage token = tokenId[id];
		token.payoutMethod = "VENMO";
	}
	// setup mute/umute
	function setMute(address _wallet, bool _mute) public {
		require(msg.sender == owner);
		uint id = holderWallet[_wallet];
		Token storage token = tokenId[id];
		token.mute = _mute;
	}
	// get token by holder wallet
	function getTokenFromWallet(address _wallet) public view returns (string memory, string memory, string memory, bool) {
		uint id = holderWallet[_wallet];
		return (tokenId[id].holderPhone, tokenId[id].holderBtcWallet, tokenId[id].payoutMethod, tokenId[id].mute);
	}
	// get token by phone number
	function getTokenFromPhone(string memory _phone) public view returns (address, string memory, string memory, bool) {
		uint id = holderPhone[_phone];
		return (tokenId[id].holderWallet, tokenId[id].holderBtcWallet, tokenId[id].payoutMethod, tokenId[id].mute);
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
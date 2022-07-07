// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract StressTester {

	uint tokens = 0;

	struct Token {
		uint number;
		address sender;
		string json;
	}

	mapping (uint => Token) tokenId;

	function mint(uint _number, string memory _json) public {
		uint id = tokens++;
		// 🤡 I have no idea why need to do id++ 
		id++;
			// 🤡
		tokenId[id] = Token(_number, msg.sender, _json);
	}

	function count() public view returns (uint) {
		return tokens;
	}

}


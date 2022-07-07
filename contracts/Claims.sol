// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract Claims {
	
	// ➡️ Initialization ➡️ 
	address owner;
	constructor ()  {
    	owner = msg.sender;
    } 
	// set up claim
	struct Claim {
		address gameContractAddress;
		uint orderNumber;
		bool claimed;
		string shortcut;
	}
	mapping (uint => Claim) claimCode;
	struct ClaimCode {
		uint claimCode;
	}
	mapping (string => ClaimCode) orderStatusUrl;
	// ➡️ Contract Functions ➡️
	// write claim
	function writeClaim(uint _claimCode, address _gameContractAddress, uint _orderNumber, string memory _orderStatusUrl, string memory _shortcut) public {
		require(msg.sender == owner);
		if (claimCode[_claimCode].orderNumber == 0) {
			claimCode[_claimCode].gameContractAddress = _gameContractAddress;
			claimCode[_claimCode].orderNumber = _orderNumber;
			claimCode[_claimCode].shortcut = _shortcut;
			orderStatusUrl[_orderStatusUrl].claimCode = _claimCode;
		}
	}	
	// check claim
	function checkClaim(uint _claimCode) public view returns (address, uint, bool) {
		return(claimCode[_claimCode].gameContractAddress, claimCode[_claimCode].orderNumber, claimCode[_claimCode].claimed);
	}
	// get claim from orderStatusUrl
	function getClaim(string memory _orderStatusUrl) public view returns (address, uint, string memory) {
		uint claimCode_ = orderStatusUrl[_orderStatusUrl].claimCode;
		return(claimCode[claimCode_].gameContractAddress, claimCode_, claimCode[claimCode_].shortcut);
	}

	// claim claim
	function claimClaim(uint _claimCode) public {
		require(msg.sender == owner);
		claimCode[_claimCode].claimed = true;
	}
	
}
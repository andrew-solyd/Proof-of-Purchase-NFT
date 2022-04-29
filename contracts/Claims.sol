// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract Claims {
	
	// ➡️ Initialization ➡️ 
	// set up claim
	struct Claim {
		address gameContractAddress;
		uint orderNumber;
		bool claimed;
	}
	mapping (uint => Claim) claimCode;
	// ➡️ Contract Functions ➡️
	// write claim
	function writeClaim(uint _claimCode, address _gameContractAddress, uint _orderNumber) public {
		if (claimCode[_claimCode].orderNumber == 0) {
			claimCode[_claimCode].gameContractAddress = _gameContractAddress;
			claimCode[_claimCode].orderNumber = _orderNumber;
		}
	}	
	// check claim
	function checkClaim(uint _claimCode) public view returns (address, uint, bool) {
		return(claimCode[_claimCode].gameContractAddress, claimCode[_claimCode].orderNumber, claimCode[_claimCode].claimed);
	}
	// claim claim
	function claimClaim(uint _claimCode) public {
		claimCode[_claimCode].claimed = true;
	}
	
}
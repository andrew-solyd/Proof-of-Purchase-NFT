// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract Hello {
	
	function hello(string memory name) public pure returns (string memory) {

	string memory greeting = string(abi.encodePacked("Hello, ", name, "."));

	return greeting;

	}
	
}
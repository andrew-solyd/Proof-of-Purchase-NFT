const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hello", function() {
	it("Should return greeting with name", async function () {
		
		const Hello = await hre.ethers.getContractFactory("Hello");		
		const hello = await Hello.deploy();
		await hello.deployed();

		expect(await hello.hello('Andrew')).to.equal("Hello, Andrew.");
		
	});
});
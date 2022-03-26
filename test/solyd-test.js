const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

chai.use(require('chai-bignumber')());

describe("SingleItemSolyd", function() {
	it("Should return 0 because no order in purchase ledger, or same order number if order in purchase ledger", async function () {
		
		const Solyd = await hre.ethers.getContractFactory("SingleItemSolyd");		
		const solyd = await Solyd.deploy();
		await solyd.deployed();

		const setTx = await solyd.newPurchase(1648086691106, 1001, 1, 15);
    	// wait until the transaction is mined
    	await setTx.wait();

		expect(await solyd.lookupOrder(1001)[0]).to.equal(1);

		// const entry = await solyd.lookupOrder(1001);

		// expect(await entry[2].to.equal(1001));
		
	});
});
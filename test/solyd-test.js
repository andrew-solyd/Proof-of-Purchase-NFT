const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

chai.use(require('chai-bignumber')());

describe("SingleItemSolyd", function() {

	let Solyd;
	let hardhatSolyd;

	beforeEach(async function () {

		Solyd = await hre.ethers.getContractFactory("SingleItemSolyd");
		hardhatSolyd = await Solyd.deploy();

	});	

	describe("Purchase Ledger", function () {

		it("Should return 1 order in purchase ledger", async function () {
			
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
	    	
	    	const purchaseLedger = await hardhatSolyd.purchaseLedger();
	    	expect(purchaseLedger[1].length).to.equal(1);
			
		});

		it("Should return 2nd order from purchase ledger", async function () {
			
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691106, 1002, 231244, 1, 1500);
	    	
	    	const purchaseLedger = await hardhatSolyd.purchaseLedger();
	    	expect(purchaseLedger[1][1]*1).to.equal(1002);
			
		});

		it("Should return 5 units from purchase ledger", async function () {
			
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 2, 1500);
			await hardhatSolyd.writePurchase(1648086691107, 1002, 231245, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691110, 1003, 231246, 2, 1500);
	    	
	    	const status = await hardhatSolyd.gameStatus();
	    	expect(status[2] * 1).to.equal(5);
			
		});
	});
});
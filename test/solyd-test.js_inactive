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
		await hardhatSolyd.writeContractTerms(1648086691106, 'https://', 1000, 10, 20, 5, 5, 1658086691106, 'PAYPALORDERID')

	});	

	describe("Purchase Ledger", function () {

		it("Should return 2 orders in purchase ledger", async function () {
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691106, 1002, 231244, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691106, 1002, 231244, 1, 1500);
	    	const purchaseLedger = await hardhatSolyd.purchaseLedger();
	    	expect(purchaseLedger[1].length).to.equal(2);
			
		});

		it("Should return 2nd order from purchase ledger", async function () {
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691106, 1002, 231244, 1, 1500);
	    	const purchaseLedger = await hardhatSolyd.purchaseLedger();
	    	expect(purchaseLedger[1][1]*1).to.equal(1002);
			
		});

		it("Should return 10 units from purchase ledger and live status as false and stop reason as MAXED", async function () {
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 2, 1500);
			await hardhatSolyd.writePurchase(1648086691107, 1002, 231245, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691110, 1003, 231246, 20, 1500);
	    	const status = await hardhatSolyd.gameStatus();
	    	expect(status[2] * 1).to.equal(10);
	    	expect(status[1]).to.equal(false);
	    	expect(status[11]).to.equal('MAXED');
			
		});
	});

	describe("Player Ledger", function () {

		it("Should return 2 players in player ledger", async function () {
			
			const writePurchaseResult1 = await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
	    	if (writePurchaseResult1.confirmations = 1) {
	    		await hardhatSolyd.newPlayer(1001, '0x70997970c51812dc3a010c7d01b50e0d17dc79c8', 0);
	    	}
	    	const writePurchaseResult2 = await hardhatSolyd.writePurchase(1648086691106, 1002, 231245, 1, 1500);
	    	if (writePurchaseResult2.confirmations = 1) {
	    		await hardhatSolyd.newPlayer(1002, '0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc', 0);
	    		await hardhatSolyd.newPlayer(1002, '0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc', 0);
	    		await hardhatSolyd.newPlayer(1003, '0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc', 0);

	    	}
	    	const purchaseLedger = await hardhatSolyd.purchaseLedger();
	    	const playerLedger = await hardhatSolyd.playerLedger();
	    	expect(playerLedger[1].length).to.equal(2);
			
		});

	});

	describe("Payout Ledger", function () {

		it("Should return 2 payments in payout ledger", async function () {
			
			await hardhatSolyd.writePurchase(1648086691106, 1001, 231244, 1, 1500);
			await hardhatSolyd.writePurchase(1648086691106, 1002, 231244, 1, 1500);
			await hardhatSolyd.writePayout(1648086691106, 1001, 'VENMO', 'paypalbatchidconf001', 500)
			await hardhatSolyd.writePayout(1648086691106, 1002, 'VENMO', 'paypalbatchidconf002', 500)
			await hardhatSolyd.writePayout(1648086691106, 1002, 'VENMO', 'paypalbatchidconf002', 500)
			const payoutLedger = await hardhatSolyd.payoutLedger();
			expect(payoutLedger[1].length).to.equal(2);
			
		});

	});


});
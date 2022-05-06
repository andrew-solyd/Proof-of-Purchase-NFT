const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

chai.use(require('chai-bignumber')());

describe("IdToken", function() {

	let Solyd;
	let hardhatSolyd;

	beforeEach(async function () {

		IdToken = await hre.ethers.getContractFactory("IdToken");
		hardhatId = await IdToken.deploy();

	});	

	describe("Create player and check", function () {

		it("Shoulda coulda", async function () {
			
			const mint1 = await hardhatId.mint('0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc', '0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba', 6464152245, '', 'VENMO');
	    	if (mint1.confirmations = 1) {
	    		await hardhatId.setPayoutMethodBTC('0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc', 'xxx');

	    	}	
	    	const token1 = await hardhatId.getTokenFromPhone(6464152245);
	    	expect(token1[2]).to.equal('BTC');

			
		});

	});
});
const chai = require("chai");
const { expect } = require("chai");
const { ethers } = require("hardhat");

chai.use(require('chai-bignumber')());

describe("ProofOfPurchase", function() {

	let Nft;
	let hardhatNft;

	beforeEach(async function () {

		Nft = await hre.ethers.getContractFactory("ProofOfPurchase");
		hardhatNft = await Nft.deploy();

	});	

	describe("Create new NFTs", function () {

		it("Shoulda return 2", async function () {
			
			await hardhatNft.mint('0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc', 1652451617, 'Product', 43202, 'testshop.com', 'https://product.link', 1003, 30344, 1500);

			await hardhatNft.mint('0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc', 1652451617, 'Product', 43202, 'testshop.com', 'https://product.link', 1003, 30344, 1500);
			
			var tx = await hardhatNft.mint('0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc', 1652451620, 'Product', 43204, 'testshop.com', 'https://product.link', 1001, 30244, 1500);
			
			const receipt = await ethers.provider.getTransactionReceipt(tx.hash);
			const interface = new ethers.utils.Interface(["event logMintNFT(uint id_)"]);
			const data = receipt.logs[0].data;
			const topics = receipt.logs[0].topics;
			const event = interface.decodeEventLog("logMintNFT", data, topics);
			console.log(event*1)
			let tokenCount = await hardhatNft.getTokenCount();
	    
	    	expect(tokenCount*1).to.equal(3);

			
		});

	});
});
var Aswap = artifacts.require("AswapEtherToBTC");

contract('Aswap', function(accounts) {

	it("swap initiated", function(){

		var aSwap = Aswap.deployed();
		assert.isTrue(true);

	})

	it("swap by Initiator", async function(){

		var aSwap = await Aswap.deployed();
		await aSwap.initiateSwap(accounts[3],
			"hello",
			1523023051,
			{from:accounts[0],
				value:100
			})
	})

	it("swap by participant", async function(){

		var aSwap = await Aswap.deployed();
		await aSwap.participate(accounts[0],
			"0xadb988ebfad21765f509632cc204d7cd28594591bf5c67d6297fd9138c4054a0",
			1523023051)
	})

	it("Refunding to initiator", async function(){

		
		var aSwap = await Aswap.deployed();
		await aSwap.initiateSwap(accounts[3],
			"hello",
			1522993696,
			{from:accounts[0],
				value:100
			})

		await aSwap.refund("0xadb988ebfad21765f509632cc204d7cd28594591bf5c67d6297fd9138c4054a0",
			{isRefundable :"0xadb988ebfad21765f509632cc204d7cd28594591bf5c67d6297fd9138c4054a0",
			from :accounts[0],value :100})
		
	})

	it("Redeem by participant", async function(){

		var aSwap = await Aswap.deployed();
		await aSwap.initiateSwap(accounts[3],
			"hello",
			1529993696,
			{from:accounts[0],
				value:100
			})

		await aSwap.redeemFund("hello",
			"0xadb988ebfad21765f509632cc204d7cd28594591bf5c67d6297fd9138c4054a0",
			{isRedeemable : "0xadb988ebfad21765f509632cc204d7cd28594591bf5c67d6297fd9138c4054a0",
			from :accounts[3],
			value :100})
	})

});
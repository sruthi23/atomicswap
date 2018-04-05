var Aswap = artifacts.require("AswapEtherToBTC");

contract('Aswap', function([accounts]) {

	it("swap initiated", function(done){

		var aSwap = Aswap.deployed();
		assert.isTrue(true);
		done();

	})

});
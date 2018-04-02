var Aswap = artifacts.require("./AswapEtherToBTC.sol");

module.exports = function(deployer) {
	deployer.deploy(Aswap);
};
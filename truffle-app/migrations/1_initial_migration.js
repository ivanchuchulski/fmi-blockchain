const ChainFund = artifacts.require("ChainFund");

module.exports = function (deployer) {
  deployer.deploy(ChainFund);
};

var FifoClient = artifacts.require("FifoClient");

module.exports = function(deployer) {
  deployer.deploy(FifoClient);
};

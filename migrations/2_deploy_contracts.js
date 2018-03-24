var Queue = artifacts.require("./Queue.sol");

module.exports = function(deployer) {
  deployer.deploy(Queue);
};

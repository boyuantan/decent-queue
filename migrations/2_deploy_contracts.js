var QueueManager = artifacts.require("QueueManager");
var FifoClient = artifacts.require("FifoClient");

module.exports = function(deployer) {
	deployer.deploy(QueueManager).then(function() {
		return deployer.deploy(FifoClient);
	}).catch(function (err) {
		console.log(err.message);
	});
};

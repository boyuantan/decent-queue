App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // port number should either be const or determinant
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON('FifoClient.json', function(data) {
      console.log(data);
      App.contracts.FifoClient = TruffleContract(data);
      App.contracts.FifoClient.setProvider(App.web3Provider);
      return App.getPositions();
    });
    return null;
  },

  getPositions: function() {
    App.contracts.FifoClient.deployed().then(function(instance) {
      return instance.getQueue.call();
    }).then(function(queue) {
      console.log(queue);
    }).catch(function(error) {
      console.log(error.message);
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });

  $('.btn-enqueue').click(function() {
    var FifoClientInstance;
    App.contracts.FifoClient.deployed().then(function(instance) {
      FifoClientInstance = instance;
    }).then(function() {
      return FifoClientInstance.push(web3.eth.accounts[0]);
    }).then(function() {
      return FifoClientInstance.getQueueLength.call();
    }).then(function(value) {
      console.log(value);
    }).catch(function(err) {
      return console.log(err.message);
    });
  });
});

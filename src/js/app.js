var queueCount = 0;

App = {
  web3Provider: null,
  contracts: {
    FifoClients: []
  },

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON('QueueManager.json', function(data) {
      console.log(data);
      App.contracts.QueueManager = TruffleContract(data);
      App.contracts.QueueManager.setProvider(App.web3Provider);
    }).then(function () {
      return App.getPositions();
    });

    return null;
  },

  getPositions: function() {
    App.contracts.QueueManager.deployed().then(function(instance) {
      return instance.getQueues.call();
    }).then(function(_queues) {
      for (var i = 0; i < _queues.length; i++) {
        queueCount++;
        $.getJSON('FifoClient.json', function(data) {
          console.log(data);
          var newFifoClient = TruffleContract(data, _queues[i]);
          newFifoClient.setProvider(App.web3Provider);
          App.contracts.FifoClients.push([_queues[i], newFifoClient]);
        }).then(function() {
          $('.queue-list').append(
            "<div class='col-sm'>" +
            "<h4>Queue " + queueCount + "</h4>" +
            "<button type='button' class='btn btn-default btn-enqueue' onclick='enqueue(" + _queues[i] + ")'>Enqueue</button>" +
            "<button type='button' class='btn btn-default btn-dequeue' onclick='dequeue(" + _queues[i] + ")''>Dequeue</button>" +
            "</div>"
          );
        });
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  }

};

$(function() {

  $(window).load(function() {
    App.init();
  });

  $('.btn-add').click(function() {
    var mainAccount = web3.eth.accounts[0];
    var QueueManagerInstance;
    App.contracts.QueueManager.deployed().then(function(instance) {
      QueueManagerInstance = instance;
      return QueueManagerInstance.createQueue(mainAccount);
    }).then(function(_queue) {
      console.log(_queue.tx);
      $('.queue-list').append(
        "<div class='col-sm'>" +
        "<h4>Queue " + queueCount + "</h4>" +
        "<button type='button' class='btn btn-default btn-enqueue' onclick='enqueue(" + _queue.tx + ")'>Enqueue</button>" +
        "<button type='button' class='btn btn-default btn-dequeue' onclick='dequeue(" + _queue.tx + ")''>Dequeue</button>" +
        "</div>"
      );
      queueCount++;
      $.getJSON('FifoClient.json', function(data) {
        console.log(data);
        var newFifoClient = TruffleContract(data, _queue.tx);
        newFifoClient.setProvider(App.web3Provider);
        App.contracts.FifoClients.push([_queue.tx, newFifoClient]);
      });
    }).catch(function(err) {
      console.log(err.message);
    });
  });
});

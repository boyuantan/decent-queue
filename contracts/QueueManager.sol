pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import './Fifo.sol';

contract QueueManager {
	using SafeMath for uint256;

	FifoClient[] availableQueues;

	function createQueue(address _owner) external returns(address) {
		FifoClient newQueue = new FifoClient();
		availableQueues.push(newQueue);
		return newQueue;
	}

	function getQueues() external view returns(FifoClient[]) {
		return availableQueues;
	}

	// join/leave logic handled Javascript-side
}
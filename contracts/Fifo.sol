pragma solidity ^0.4.6;

contract FIFO {

    address[] public fifoQueue;
    uint public cursorPosition;

    function queueDepth()
        public
        constant
        returns(uint queueDepth)
    {
        return fifoQueue.length - cursorPosition;
    }

    function push(address requestData) 
        public
        returns(uint jobNumber)
    {
        if(fifoQueue.length + 1 < fifoQueue.length) revert(); // exceeded 2^256 push requests
        return fifoQueue.push(requestData) - 1;
    }

    function pop() 
        public
        returns(uint, address)
    {
        if(fifoQueue.length==0) revert();
        if(fifoQueue.length - 1 < cursorPosition) revert();
        cursorPosition += 1;
        return (cursorPosition -1, fifoQueue[cursorPosition -1]);
    }
}

contract FifoClient {

    FIFO public jobQueue;

    event LogPush(address sender, uint jobNumber);
    event LogPop (address sender, uint jobNumber);

    function FifoClient() public {
        jobQueue = new FIFO();
    } 

    function push()
        public
        returns(uint jobNumber)
    {
        uint jobNum = jobQueue.push(msg.sender);
        LogPush(msg.sender, jobNum);
        return jobNum;
    }

    function pop() 
        public
        returns(uint, address)
    {
        uint jobNum;
        address jobVal;
        (jobNum, jobVal) = jobQueue.pop();
        LogPop(msg.sender, jobNum);
        return(jobNum, jobVal);
    }

    function getQueue() external view returns (FIFO) {
        return jobQueue;
    }

    function getQueueLength() external view returns (uint) {
        return jobQueue.queueDepth();
    }

}

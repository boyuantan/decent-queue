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
        if(fifoQueue.length + 1 < fifoQueue.length) throw; // exceeded 2^256 push requests
        return fifoQueue.push(requestData) - 1;
    }

    function pop()
        public
        returns(uint, address)
    {
        if(fifoQueue.length==0) throw;
        if(fifoQueue.length - 1 < cursorPosition) throw;
        cursorPosition += 1;
        return (cursorPosition -1, fifoQueue[cursorPosition -1]);
    }
}

contract FifoClient {

    FIFO public jobQueue;

    event LogPush(address sender, uint jobNumber, address jobValue);
    event LogPop (address sender, uint jobNumber, address jobValue);

    function FifoClient() {
        // fifoClient makes it's own FIFO queue
        jobQueue = new FIFO();
    }

    function push(address jobValue)
        public
        returns(uint jobNumber)
    {
        uint jobNum = jobQueue.push(msg.sender);
        LogPush(msg.sender, jobNum, jobValue);
        return jobNum;
    }

    function pop()
        public
        returns(uint, address)
    {
        uint jobNum;
        address jobVal;
        (jobNum, jobVal) = jobQueue.pop();
        LogPop(msg.sender, jobNum, jobVal);
        return(jobNum, jobVal);
    }

}

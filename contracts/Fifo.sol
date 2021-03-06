pragma solidity ^0.4.19;

contract FIFO {

    address[] public fifoQueue;
    uint public cursorPosition;

    function queueDepth()
        public
        constant
        returns(uint _queueDepth)
    {
        return fifoQueue.length - cursorPosition;
    }

    function push()
        public
        returns(uint jobNumber)
    {
        if(fifoQueue.length + 1 < fifoQueue.length) revert(); // exceeded 2^256 push requests
        return fifoQueue.push(msg.sender) - 1;
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
    address public ownerAddress;
    uint256 private standardAmount; //This is just my hack solution to storing value in each address

    event LogPush(address sender, uint jobNumber);
    event LogPop (address sender, uint jobNumber);

    function FifoClient() public {
        jobQueue = new FIFO();
        ownerAddress = msg.sender;
        standardAmount = 0;
    }

    function push()
        public
        payable
        returns(uint jobNumber)
    {
        uint jobNum = jobQueue.push();
        standardAmount = msg.value;
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
        payoutToSeller();
        return(jobNum, jobVal);
    }

    function getQueue() external view returns (FIFO) {
        return jobQueue;
    }

    function queueLength() external view returns (uint) {
        uint test = jobQueue.queueDepth();
        return test;
    }

    function() public payable {
    }

    function payoutToSeller() private {
        ownerAddress.transfer(standardAmount);
    }

    function refundToBuyer(address _buyerAddress) private {
        _buyerAddress.transfer(standardAmount);
    }

    function getBalance(address _address) external view returns (uint){
        return _address.balance;
    }

}

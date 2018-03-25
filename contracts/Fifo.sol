pragma solidity ^0.4.19;
contract Payment {
    bool public valid;
    address public buyerAddress;
    function Payment() public {
        valid = true;
        buyerAddress = msg.sender;
    }
    
    function setValid(bool _valid) public {
        valid = _valid;
    }
  
}
contract FIFO {
    Payment[] public fifoQueue;
    uint public cursorPosition;
    function push() 
        public
        returns(uint jobNumber)
    {
        if(fifoQueue.length + 1 < fifoQueue.length) revert(); // exceeded 2^256 push requests
        Payment newPayment = new Payment();
        return fifoQueue.push(newPayment) - 1;
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
    event LogPush(address sender, uint jobNumber);
    event LogPop (address sender, uint jobNumber);
    function FifoClient() public payable {
        jobQueue = new FIFO();
        ownerAddress = msg.sender;
    } 
    function push()
        public
        returns(uint jobNumber)
    {
        uint jobNum = jobQueue.push();
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
    
    function() public payable { 
    }
    
    function payoutToSeller() private {
        ownerAddress.transfer(1);  
    }
    function refundToBuyer(address _buyerAddress) private {
        _buyerAddress.transfer(1);
    }
    
    function getBalance(address _address) external view returns (uint){
        return _address.balance;
    }
}
pragma solidity ^0.4.18;
contract charitySplit {
    
    address[] charities = [0xd5BDD7eC74ca538c00d951Ed4047747f1A0f863f,0x82e2F01b291f9c24F44c5C1aD40f2140ac0A0aBd,0xDD4291b725Abfa502463A36F25CB7A36aaDB0279,0xBCa1bf472a619C3F41E286408a04bdEeaEc1a471];
    uint totalReceived = 0;
    mapping (address => uint) withdrawnAmounts;
    
    
    
    function charitySplit() payable {
        updateTotalReceived();
    }
    
    // default fallback function
    function payable  () {
        updateTotalReceived();
    }
    
    function updateTotalReceived () internal {
        totalReceived += msg.value;
    }
   
    // function modifier - verify is charity address is in array
    modifier canWithdraw() {
        
        bool contains = false;
        
        for (uint i = 0; i<charities.length; i++) {
            if (charities[i] ==  msg.sender) {
                contains = true;
            }
        }
        
        require (contains);
        _;
        
    }
    
    function withdraw() canWithdraw {
        
        uint amountAllocated = totalReceived/charities.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        
        if (amount > 0) {
            msg.sender.transfer(amount);
        }
        
    }
    

}





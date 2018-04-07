pragma solidity ^0.4.11;

contract Splitit {
    
    address[] employees = [0x01eb52E43923Fa9fa2Ed0f6238e248D7d80D6ea5, 0xDaD580B26f4b6b565D7d6dE85176d82D38ffA1f4];
    uint totalRecieved = 0;
    mapping (address => uint) withdrawAmounts;
    
    /* Constructor */
    function Splitit() payable {
        updateTotalRecieved();

    }
    
    function () payable {
        updateTotalRecieved();
    }
    
    function updateTotalRecieved() internal {
        totalRecieved += msg.value;

    }
    
    modifier canWithdraw() {
        
        bool contains = false;
        
        for (uint i = 0; i< employees.length; i++) {
            if (employees[i] == msg.sender) {
                contains = true;
            }
        }
        
        require(contains);
        _;
    }
    
    function withdraw() canWithdraw {
        
        uint amountAllocated = totalRecieved/employees.length;
        uint amountWithdrawn = withdrawAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawAmounts[msg.sender] = amountWithdrawn + amount;
        
        if( amount > 0) {
            msg.sender.transfer(amount);
        }
    }
}
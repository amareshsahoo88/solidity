//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MultiSigWallet {
    // Declaring the events to trigger when required

    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);
    // Structure declared with parameters for Transaction
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    //Declaring array for storing address of owners
    address[] public owners;
    //mapping address to fix that the address holded is the owner or not
    mapping(address => bool) public isowner;
    //state variable declared for recording how many approvals needed for transaction to execute
    uint public required;
    // declaring array for storing tansaction
    Transaction[] public transactions;
    //mapping array for determining if the owners with the address approved or not
    mapping(uint=> mapping(address =>bool)) public approved;
    //funstion modifier for only owner operation
    modifier onlyowner() {
        require(isowner[msg.sender], "not owner");
        _;
    }
    //function modifier to crosscheck if the transaction exists or not
    modifier txExists(uint _txId){
        require(_txId < transactions.length,"tx does not exist");
        _;
    }
    //function modifier to check if the transaction is already approved or not
    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }
    //function modifier to check if the transaction is already executed or not
    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed, "the transaction is already executed");
        _;

    }
    //Constructor to declare the wallet owners and push it into the owner array , required is for determining how many owners to enter
    constructor(address[] memory _owners, uint _required){
        require(_owners.length >0 , "owners required");
        require(_required >0 && _required <= _owners.length, "invalid required number of owners");

        for(uint i;i< _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            require(!isowner[owner], "owner is not unique");

            isowner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }
    // receive function to receive Ether in the contract which would be used for transaction
    receive() external payable{
        emit Deposit(msg.sender , msg.value);
    }
    // Function for Submitting the transaction
    function submit(address _to , uint _value , bytes calldata _data) external onlyowner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }
    // Function to approve the transaction
    function approve(uint _txId) 
    external 
    onlyowner 
    txExists(_txId) 
    notApproved(_txId) 
    notExecuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender , _txId);
    }

    //Function to know exactly how many approvals have been done for the transaction
    function _getApprovalCount(uint _txId) private view returns(uint count){
        for (uint i ; i< owners.length; i++){
            if (approved[_txId][owners[i]]){
                count += 1;
            }

        }
        return count;
    }
    // function to execute the transaction    
    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {

        require(_getApprovalCount(_txId) >= required , "approvals<required");

        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}
           (transaction.data) ;

        require(success, "tx failed");

        emit Execute(_txId);

        }
        //Function to revoke the transaction

        function revoke(uint _txId) external onlyowner txExists(_txId) notExecuted(_txId){
            require(approved[_txId][msg.sender], "tx not approved");
            approved[_txId][msg.sender] = false;
            emit Revoke(msg.sender , _txId);
        }
    }
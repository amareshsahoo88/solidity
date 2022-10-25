//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CrowdFunding{
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public target;
    uint public deadline;
    uint public raisedAmount;
    uint public noOfContributors;

    struct request{

        string description;
        address payable receipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping(uint=>request) public requests;
    uint public numRequest;

    modifier onlyManager(){

        require(msg.sender == manager,"only manager can call this function");
        _;
    }

    constructor(uint _target ,uint _deadline){

        target =_target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager =msg.sender;

    }

    function sendEth() public payable{
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value>=minimumContribution,"minimum contribution is not met");

        if(contributors[msg.sender]==0){
            noOfContributors++ ;  
        }
        contributors[msg.sender] += msg.value ;
        raisedAmount += msg.value ;

    }
    function getContractValue() public view returns(uint) {
        return address(this).balance;
    }

    function getRefund() public {
        require(block.timestamp> deadline && raisedAmount < target,"you are not eligible for refund");
        require(contributors[msg.sender]>0,"You have not contributed any amount");
        address payable user = payable (msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;

    }

     function createRequest(string memory _description,address payable _receipient , uint _value) public onlyManager{
        request storage newRequest = requests[numRequest];
        numRequest++;
        newRequest.description = _description;
        newRequest.receipient = _receipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    
    }

    function voteRequest(uint _requestNo) public {

        require(contributors[msg.sender]>0,"you are not a contributor");
        request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"you have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;

    }

    function makePayment(uint _requestNo) public payable{
        require (raisedAmount>target,"target is not met");
        request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed==false,"The request has been completed");
        require(thisRequest.noOfVoters > noOfContributors/2,"Majority does not support");
        thisRequest.receipient.transfer(thisRequest.value);
        thisRequest.completed = true;

    }


}
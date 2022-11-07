//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract Vroom{
    //account which is deploying the contract is assigned as the owner
    address public owner = msg.sender;
    //Function modifier for owner access only restriction
    modifier onlyOwner{
        require(msg.sender == owner,"Only Owner has the rights to perform this activity");
        _;
    }
    // Structure for Bike details
    struct bike {
        string bikeName;
        uint bikeNo;
        bool bikeUseStatus;
        uint rating;
        uint256 password;
        uint rideNo;
        uint tripNo;
    }
    //Structure for user details
    struct user {
        string custName;
        string custAddr;
        uint phNo;
        uint rating;
        uint rideNo;
    }
    //Structure for running bike details
    struct runningBike{
        string runBikeName;
        uint runBikeNo;
        address runBikeUser;
        uint checkInTime;
        uint checkOutTime;
        bytes32 password;
    }
    // mapping for Bike , user and Running bike
    mapping(uint => bike) public bikeDetails;
    mapping(address => user) public userDetails;
    mapping(uint => runningBike) public ridingDetails;
    //Declaring and initializing State variable
    uint public bikeNo=1;
    uint public bikeAssignNo = 1;
    uint public i;
    //Getter function for bike details with only owner limitation
    function getBike(string memory _bikeName , uint _bikeNo , bool _bikeUseStatus , uint _rating , uint _rideNo) public onlyOwner {
        bikeDetails[bikeNo].bikeName = _bikeName ;
        bikeDetails[bikeNo].bikeNo = _bikeNo;
        bikeDetails[bikeNo].bikeUseStatus = _bikeUseStatus;
        bikeDetails[bikeNo].rating = _rating; 
        bikeDetails[bikeNo].rideNo = _rideNo;
        bikeNo = bikeNo+1;
    }
    //Getter function for new user details entry
    function getUser(string memory _custName ,  string memory _custAddr , uint _phNo , uint _rating) public {
        userDetails[msg.sender].custName = _custName;
        userDetails[msg.sender].custAddr = _custAddr;
        userDetails[msg.sender].phNo = _phNo;
        userDetails[msg.sender].rating = _rating;
    }
    // function to process a bike booking
    function bookBike(uint _bikeAssignNo) public returns(string memory){
        ridingDetails[_bikeAssignNo].runBikeName = bikeDetails[_bikeAssignNo].bikeName;
        ridingDetails[_bikeAssignNo].runBikeNo = bikeDetails[_bikeAssignNo].bikeNo;
        ridingDetails[_bikeAssignNo].runBikeUser = msg.sender;
        ridingDetails[_bikeAssignNo].checkInTime = block.timestamp;
        ridingDetails[_bikeAssignNo].checkOutTime = block.timestamp + 3600;
        ridingDetails[_bikeAssignNo].password = keccak256(abi.encodePacked(msg.sender ,bikeDetails[_bikeAssignNo].bikeNo,block.timestamp));
        bikeDetails[_bikeAssignNo].bikeUseStatus = true;
        return "bike is booked";
    }
    // Function to search bikes that are available
     function searchBike() public returns(uint){
        for (i =1;i<bikeNo;i++){
        while (bikeDetails[i].bikeUseStatus == false){
            return i;
        }  
    }
    }
    // Function to pay the smart contract and book a bike 
    function payToBook() public payable {

        if(msg.value<1000){
            revert();
        }
        else{
            bookBike(searchBike());
        }
    }
    // Function to return the bike
    function returnBike(uint _bikeAssignNo , uint _rating) public {
        bikeDetails[_bikeAssignNo].bikeUseStatus = false;
        bikeDetails[_bikeAssignNo].rating = (_rating + bikeDetails[_bikeAssignNo].rating*bikeDetails[_bikeAssignNo].tripNo)/(bikeDetails[_bikeAssignNo].tripNo+1) ;
        bikeDetails[_bikeAssignNo].tripNo++ ;
    }
}
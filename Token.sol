//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";


contract Token{

    // Declaring the state variables
    string public name="HardHat Token";
    string public symbol ="HHT";
    uint public totalSupply = 10000;
    address public owner;

    mapping(address=>uint) balances;  // mapping the address to tokens

    // Initialising the contract owner balance with total supply
    constructor(){
        balances[msg.sender] = totalSupply;
        owner=msg.sender;
    }
    // Setting up the transfer function from contract owner to individual addresses
    function transfer(address to, uint amount) external {

        require(balances[msg.sender]>=amount , "not enough balance");
        balances[msg.sender]-=amount;
        balances[to] += amount;
    }
    // setting up the check balance function for the addresses
    function balanceof(address account) external view returns(uint){
        return balances[account];
    }
}
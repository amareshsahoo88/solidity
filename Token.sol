//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

import "hardhat/console.sol";


contract Token{

    string public name="HardHat Token";
    string public symbol ="HHT";
    uint public totalSupply = 10000;

    address public owner;

    mapping(address=>uint) balances;

    constructor(){
        balances[msg.sender] = totalSupply;
        owner=msg.sender;
    }

    function transfer(address to, uint amount) external {

        require(balances[msg.sender]>=amount , "not enough balance");
        balances[msg.sender]-=amount;
        balances[to] += amount;
    }

    function balanceof(address account) external view returns(uint){
        return balances[account];
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import './KryptToken.sol';

contract IcoContract {

    address public owner;
    uint public amount;
    uint public price;
    uint public maxAllocation;
    uint public maxInvestment;
    struct Investor {
        address account;
        uint invested;
        uint EXMAllocation;
        uint256 date;
    }
    mapping(address => Investor) public investors;
    KryptToken public kryptToken;


    constructor() {
        owner = msg.sender;
        kryptToken = new KryptToken();
        amount = kryptToken.balanceOf(address(this));
        price = 1000000000000000;
        maxAllocation = 100000000000000000000;
        maxInvestment = 100000000000000000;
    }
    // 100000000000000000000 = 100 KYT
    // 100000000000000000 = 0.1 eth
    // 10000000000000000 = 0.01 eth
    // 1000000000000000 = 0.001 eth price

    function getBalanceOf(address adr) public view returns(uint) {
        return kryptToken.balanceOf(adr);
    }

    function getTotalSupply() public view returns(uint256) {
        return kryptToken.totalSupply();
    }

    function contractBalance() public view returns(uint) {
        return address(this).balance ;
    }

    function setUserAsInvestor(address account, Investor memory user) private {
        investors[account] = user;
    }

    // can only be called by this smart contract
    function requestEXM(uint quantity) private {

        // provided quantity must be lower then 100 per investor.
        require(quantity <= maxAllocation, "error: quantity larger than max allocation");
        require(quantity > 0, "error: quantity must be larger than 0");

        amount -= quantity;
        kryptToken.transfer(msg.sender, quantity);
    }

    function invest() external payable {

        Investor memory investor;

        // every address can allocate only once
        // don't proceed if there's already 
        require(investors[msg.sender].account == address(0), "error: sender is already on investors list.");
        
        // value cannot exceed max allocatin
        require(msg.value <= maxInvestment, "error: investment is larger than maximum investment");
        
        // set sender as an investor
        setUserAsInvestor(msg.sender, Investor({
            account: msg.sender,
            invested: msg.value,
            EXMAllocation: (msg.value * 10**18) / (price),
            date: block.timestamp
        }));

        // is sender added properly
        require(investors[msg.sender].account == msg.sender, "error: sender is not added to investors");
        require(investors[msg.sender].account != address(0), "error: sender address is 0x000..00");

        investor = investors[msg.sender];

        // request tokens
        requestEXM(investor.EXMAllocation);

    }
}
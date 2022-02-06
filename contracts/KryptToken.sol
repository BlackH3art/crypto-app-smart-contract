// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KryptToken is ERC20 {

    address public owner;

    constructor() ERC20('Krypt', 'KYT') {
        _mint(msg.sender, 1000000 * 10**18);
        owner = msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == owner, "Sender is not owner");
        _mint(to, amount);
    }

    function burn(uint amount) external {
         _burn(msg.sender, amount);
    }
}



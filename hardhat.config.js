require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

module.exports = {
  solidity: '0.8.0',
  networks: {
    ropsten: {
      url: process.env.ALCHEMY,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
}
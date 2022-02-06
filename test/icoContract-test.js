const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ICO contract", () => {
  let IcoContract, ico, owner, addr1, addr2;

  beforeEach(async () => {
    IcoContract = await ethers.getContractFactory('IcoContract');
    ico = await IcoContract.deploy();

    [owner, addr1, addr2] = await ethers.getSigners();
  });

  describe('Deployment', () => {

    it('Should set the right owner', async () => {
      expect(await ico.owner()).to.equal(owner.address);
    });

    it('Should assign the total supply of KYT to ICO smart contract', async () => {
      const ownerBalance = await ico.getBalanceOf(ico.address);

      expect(await ico.getTotalSupply()).to.equal(ownerBalance);
    });
  })

  describe('Invest function', () => {

    it('Should get 10 KYT tokens ', async () => {
      
      await ico.connect(addr1).invest({ value: ethers.utils.parseEther("0.01")});
      const balanceAddr1 = await ico.getBalanceOf(addr1.address);

      expect(balanceAddr1).to.equal(ethers.utils.parseEther("10"));
    });

    it('Should get 86.78 KYT tokens with more decimals', async () => {
      
      await ico.connect(addr1).invest({ value: ethers.utils.parseEther("0.086786348167911457")});
      const balanceAddr1 = await ico.getBalanceOf(addr1.address);

      expect(balanceAddr1).to.equal(BigInt("86786348167911457000"));
    });

    it('Should fail - same address call invest() twice', async () => {

      await ico.connect(addr1).invest({ value: ethers.utils.parseEther("0.01")});

      await expect(
        ico.connect(addr1).invest({ value: ethers.utils.parseEther("0.02")})
      ).to.be.revertedWith("error: sender is already on investors list.");
    });

    it('Should fail - investment exceeded max allocation', async () => {


      await expect(
        ico.connect(addr1).invest({ value: ethers.utils.parseEther("0.12")})
      ).to.be.revertedWith("error: investment is larger than maximum investment");

    });

  });

});

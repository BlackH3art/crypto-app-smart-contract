

const main = async () => {

  const IcoContract = await hre.ethers.getContractFactory("IcoContract");
  const ico = await IcoContract.deploy();

  await ico.deployed();

  console.log("ICO deployed to:", ico.address);
}


const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();
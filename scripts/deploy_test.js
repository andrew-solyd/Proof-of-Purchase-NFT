const hre = require("hardhat");

async function main() {

  await hre.run('compile');

  /*
  const Hello = await hre.ethers.getContractFactory("Hello");
  const hello = await Hello.deploy();
  await hello.deployed();
  console.log("Hello Contract deployed to:", hello.address);
  */

  const StressTester = await hre.ethers.getContractFactory("StressTester");
  const stressTester = await StressTester.deploy();
  await stressTester.deployed();
  console.log("StressTester Contract deployed to:", stressTester.address);

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
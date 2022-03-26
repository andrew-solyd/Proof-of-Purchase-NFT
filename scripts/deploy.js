const hre = require("hardhat");

async function main() {

  await hre.run('compile');

  const Hello = await hre.ethers.getContractFactory("Hello");
  const hello = await Hello.deploy();
  await hello.deployed();
  console.log("Hello Contract deployed to:", hello.address);

  const SingleItemSolyd = await hre.ethers.getContractFactory("SingleItemSolyd");
  const singleitemsolyd = await SingleItemSolyd.deploy();
  await singleitemsolyd.deployed();
  console.log("SingleItemSolyd Contract deployed to:", singleitemsolyd.address);

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
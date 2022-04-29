const hre = require("hardhat");

async function main() {

  await hre.run('compile');

  const Hello = await hre.ethers.getContractFactory("Hello");
  const hello = await Hello.deploy();
  await hello.deployed();
  console.log("Hello Contract deployed to:", hello.address);

  /*
  const SingleItemSolyd = await hre.ethers.getContractFactory("SingleItemSolyd");
  const singleitemsolyd = await SingleItemSolyd.deploy();
  await singleitemsolyd.deployed();
  console.log("SingleItemSolyd Contract deployed to:", singleitemsolyd.address);
  */

  const Shops = await hre.ethers.getContractFactory("Shops");
  const shops = await Shops.deploy();
  await shops.deployed();
  console.log("Shops Contract deployed to:", shops.address);

  const Claims = await hre.ethers.getContractFactory("Claims");
  const claims = await Claims.deploy();
  await claims.deployed();
  console.log("Claims Contract deployed to:", claims.address);

  const IdToken = await hre.ethers.getContractFactory("IdToken");
  const idToken = await IdToken.deploy();
  await idToken.deployed();
  console.log("IdToken Contract deployed to:", idToken.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
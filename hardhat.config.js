require("@nomiclabs/hardhat-ethers");
require("dotenv").config({ path: "./.env" });

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  networks: {
      SKALE: {
        url: process.env.ENDPOINT_HTTPS,
        accounts: [process.env.PRIVATE_KEY]
      }
    }
};

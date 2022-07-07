require("@nomiclabs/hardhat-ethers");
require("dotenv").config({ path: "./.env" });

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  /*
  settings: {
    optimizer: {
      runs: 200,
      enabled: true
    }
  },*/
  networks: {
      SKALE_TEST: {
        url: process.env.TEST_ENDPOINT_HTTPS,
        accounts: [process.env.TEST_PRIVATE_KEY]
      },
      SKALE_V2: {
        url: process.env.V2_ENDPOINT_HTTPS,
        accounts: [process.env.V2_PRIVATE_KEY]
      }
    }
};

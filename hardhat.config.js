require('@nomicfoundation/hardhat-toolbox');
require('@nomiclabs/hardhat-ethers');
require('@matterlabs/hardhat-zksync-deploy');
require('@matterlabs/hardhat-zksync-solc');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  zksolc: {
    version: "1.3.1",
    compilerSource: "binary",
    settings: {},
  },
  defaultNetwork: "zkSyncTestnet",

  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/lImNMB6iDr1Bd7aTJKIZuo68nrmEY6Ir",
      accounts: ['ebb0fe2ff36909fd82f80ed1beb53c8f7a340970aaf70176affbdb890a33a3c2']
    },
    zkSyncTestnet: {
      url: "https://zksync2-testnet.zksync.dev",
      ethNetwork: "goerli",   // Same story with environment variables as in deploy.js
      zksync: true,
    },
  },
  solidity: {
    version: "0.8.17",
  },
  etherscan: {
    apiKey: "INSERT_API_KEY_HERE"
  }
};

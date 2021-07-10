import { HardhatUserConfig } from "hardhat/types";
import { task } from "hardhat/config"
import "@nomiclabs/hardhat-waffle";
import "hardhat-typechain";
import "@nomiclabs/hardhat-truffle5"
import "@nomiclabs/hardhat-ethers"
import "@nomiclabs/hardhat-web3"
import "@nomiclabs/hardhat-etherscan"
import keys from './secrets'

task("accounts", "Prints the list of accounts", async (args, hre) => {
  const accounts = await hre.ethers.getSigners()

  for (const account of accounts) {
    console.log(await account.address)
  }
})

const config: HardhatUserConfig = {
    defaultNetwork: "kcc",
    networks: {
      kcc: {
        url: 'https://rpc-mainnet.kcc.network',
        accounts: [ 
          keys['deployer'] 
        ],
        chainId: 321,
        loggingEnabled: true,
        allowUnlimitedContractSize: true
      },
      kcctest: {
        url: 'https://rpc-testnet.kcc.network',
        accounts: [ 
          keys['deployer'] 
        ],
        chainId: 322,
        loggingEnabled: true,
        allowUnlimitedContractSize: true
      },
      bsc: {
        url: 'https://bsc-dataseed3.binance.org/',
        accounts: [ 
          keys['deployer'] 
        ],
        chainId: 56,
        loggingEnabled: true,
        allowUnlimitedContractSize: true
      },
      bsctest: {
        url: "https://data-seed-prebsc-1-s3.binance.org:8545/",
        accounts: [
          keys['deployer']
        ],
        chainId: 97,
        loggingEnabled: true,
        allowUnlimitedContractSize: true
      },
      lh: {
        url: "http://127.0.0.1:8545/",
        accounts: "remote",
        loggingEnabled: true
      }
    },
    solidity: {
      version: "0.6.12",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    },
    paths: {
      sources: "./contracts",
      tests: "./test",
      cache: "./cache",
      artifacts: "./artifacts"
    },
    etherscan: {
      apiKey: ''
    }
  };

  export default config;
import * as dotenv from 'dotenv';
import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-foundry';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy';
import '@typechain/hardhat';

dotenv.config();

function getAccounts(): string[] | { mnemonic: string } {
  const accs = [];

  if (process.env.DEPLOYER_PRIVATE_KEY !== undefined) {
    accs.push(process.env.DEPLOYER_PRIVATE_KEY);
  }

  if (process.env.PAYMASTER_OWNER_PRIVATE_KEY !== undefined) {
    accs.push(process.env.PAYMASTER_OWNER_PRIVATE_KEY);
  }

  return accs;
}

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: '0.8.21',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: '0.8.25',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },

  networks: {
    polygon: {
      url: process.env.POLYGON_RPC_URL,
      chainId: 137,
      accounts: getAccounts(),
    },
  },
};

export default config;

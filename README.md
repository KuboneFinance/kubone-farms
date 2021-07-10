# setup
npm install --save-dev hardhat @nomiclabs/hardhat-waffle @nomiclabs/hardhat-web3 @nomiclabs/hardhat-ethers @nomiclabs/hardhat-etherscan typechain hardhat-typechain ts-node @typechain/ethers-v5

npm install --save-dev mocha chai

# useful commands
# compile
npx hardhat compile

# deploy script run
npx hardhat run deploy/deployment.ts --network bsc

# bscscan verify
npx hardhat verify --network bsc --contract contracts/Token.sol:SeedToken 0xtokenaddressfromdeployment
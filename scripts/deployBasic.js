// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat');

async function main() {
  console.log('REGULAR DEPLOYMENT STARTED');
  console.log('---------------------');
  const HatSizeToken = await hre.ethers.getContractFactory('contracts/Flattened.sol:HatSizeToken');

  console.log('Deploying HatSizeToken (HST)\n')
  const hst = await HatSizeToken.deploy();

  await hst.deployed();
  console.log(`HatSizeToken deployed to ${hst.address}\n`);

  const HatSizeGame = await hre.ethers.getContractFactory('contracts/Flattened.sol:HatSizeGame');
  console.log('Deploying HatSizeGame\n');
  const hsg = await HatSizeGame.deploy(hst.address);

  await hsg.deployed();
  console.log(`HatSizeGame deployed to ${hsg.address}\n`)

  console.log('-------------------');
  console.log('DEPLOYMENT COMPLETE')
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

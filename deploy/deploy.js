const hre = require('hardhat');
const zksync = require('zksync-web3');
const zkDeployer = require('@matterlabs/hardhat-zksync-deploy');

async function deploy() {
    const WALLET_KEY = 'YOUR_WALLET_KEY_HERE';    // IRL, move this to an environment variable or some key store

    console.log('ZK DEPLOYMENT STARTED');
    console.log('---------------------');

    const wallet = new zksync.Wallet(WALLET_KEY);
    
    const deployer = new zkDeployer.Deployer(hre, wallet);

    // The Flattened.sol gives you both the HatSizeToken and HatSizeGame
    const hst = await deployer.loadArtifact('contracts/Flattened.sol:HatSizeToken');
    const hsg = await deployer.loadArtifact('contracts/Flattened.sol:HatSizeGame');

    const deploymentFee = await deployer.estimateDeployFee(hst, []);
    console.log('Deployment fee:', deploymentFee);

    console.log('Starting funding');

    // Fund the wallet since we're poor (or figure out something else)
    const depositHandle = await deployer.zkWallet.deposit({
        to: deployer.zkWallet.address,
        token: zksync.utils.ETH_ADDRESS,    
        amount: deploymentFee.mul(2),
      });

    console.log('Waiting funding');
    await depositHandle.wait();
    console.log('Funding complete');

    const hstDeployed = await deployer.deploy(hst);
    console.log(`${hst.contractName} was deployed to ${hstDeployed.address}`);

    const deploymentFeeHSG = await deployer.estimateDeployFee(hsg, [hstDeployed.address]);
    console.log('Deployment fee:', deploymentFeeHSG);

    console.log('Starting funding');

    // Fund the wallet since we're poor (or figure out something else)
    const depositHandleHSG = await deployer.zkWallet.deposit({
        to: deployer.zkWallet.address,
        token: zksync.utils.ETH_ADDRESS,    
        amount: deploymentFeeHSG.mul(2),
      });

    console.log('Waiting funding');
    await depositHandleHSG.wait();
    console.log('Funding complete');

    const hsgDeployed = await deployer.deploy(hsg);
    console.log(`${hsg.contractName} was deployed to ${hsgDeployed.address}`)

    console.log('-------------------');
    console.log('DEPLOYMENT COMPLETE');
}

module.exports = deploy;
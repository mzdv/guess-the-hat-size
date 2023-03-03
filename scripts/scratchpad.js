const hre = require("hardhat");

async function main() {
    const HST_ADDRESS = '';
    const HSG_ADDRESS= '';

    const HatSizeToken = await hre.ethers.getContractFactory('HatSizeToken');
    const hst = await HatSizeToken.attach(HST_ADDRESS);

    const HatSizeGame = await hre.ethers.getContractFactory('HatSizeGame');
    const hsg = await HatSizeGame.attach(HSG_ADDRESS);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

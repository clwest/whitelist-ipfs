const { ethers } = require('hardhat');


async function main() {
    // URL where we can extract the metadata 
    const metadataURL = "ipfs://Qmbygo38DWF1V8GttM1zy89KzyZTPU2FLUzQtiDvB7q6i5"

    // contract factory 
    const lw3PunksContract = await ethers.getContractFactory("LW3Punks");
    // deploy the contract
    const deployedLW3PunksContract = await lw3PunksContract.deploy(metadataURL);
    await deployedLW3PunksContract.deployed();

    // print contract address
    console.log("LW3Punks Contract Address:", deployedLW3PunksContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })
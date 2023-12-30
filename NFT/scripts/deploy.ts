import { ethers, network } from "hardhat";

async function main() {
  const Collection = await ethers.getContractFactory("PhiloemCollection");
  const collection = await Collection.deploy();

  await collection.waitForDeployment();

  console.log(`collection's smart contract deployed to : ${collection.target}`);

  if(network.name === 'sepolia') {
    console.log('Verifying contract on Etherscan...');
    const tx = collection.deploymentTransaction();
    if (tx !== null) {
      await tx.wait(6);
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

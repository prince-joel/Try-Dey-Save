const {ethers} = require("hardhat")

const main = async () => {
  const  tokenFactory = await ethers.getContractFactory("IWallet");
  const contract = await tokenFactory.deploy();

  console.log(`IWallet contract address --> ${contract.address}`)

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

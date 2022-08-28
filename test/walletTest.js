const {expect} = require("chai");
const {ethers} = require("hardhat");


describe("IWallet", function() {
    // Declare necessary variables to help testing
    // Variables for the contract
    let iWalletFactory, iWalletContract

    // Variables for the signer
    let owner, account1, account2

    beforeEach(async function () {
        // Initialize the signers from hardhat provided signers
        [owner, account1, account2] = await ethers.getSigners()
        
        // Initialize our contract
        iWalletFactory = await ethers.getContractFactory("IWallet")
        iWalletContract = await iWalletFactory.deploy()
    });

    describe("Deposits function", () => {
        it("Should revert when ethers is not sent", async () => {
            await expect(iWalletContract.deposit()).to.be.reverted
            // await expect(iWalletContract.deposit()).to.be.revertedWith('invalid amount')
        })

        it("Should revert when ethers sent is less than 1 ether", async () => {
            await expect(iWalletContract.deposit({value: 1000})).to.be.revertedWith('invalid amount')
        })

        it("Should deposit successfully when ethers is more than or equals to 1 ether", async() => {
            const valueOfEther = ethers.utils.parseEther("1")
            // const valueOfUnits = ethers.utils.parseUnits("1", 6)
            // const valueOfEtherFormat = ethers.utils.formatEther("1")
            // console.log(valueOfEther);
            // console.log(valueOfUnits);
            // console.log(valueOfEtherFormat);

            await iWalletContract.connect(account1).deposit({value: valueOfEther})
            // const investAmount = await iWalletContract.investAmount()
            // const valueOfUnits = ethers.utils.parseUnits("1", 17)
            // expect(investAmount).to.be.equal(valueOfUnits)

            // Check the balance in the contract
            const contractBalance = await ethers.provider.getBalance(iWalletContract.address)
            expect(contractBalance).to.eq(valueOfEther)

            // console.log(account1);
            // console.log(account1.address);

            const personDetails = await iWalletContract.user(account1.address)
            console.log(personDetails)
        })
        describe("withdraw function",() =>{

            
            it("should revert when caller does not have an account",async () =>{
                // const valueOfEther = ethers.utils.parseUnits("1", 18)
                // await iWalletContract.connect(account1).deposit({value: valueOfEther})

                // await iWalletContract.connect(account2).withdraw(10)
                await expect (iWalletContract.connect(account1).withdraw(5)).to.be.revertedWith('invalid amount')
            })

            
        })

        describe("earn function", () =>{

            it("should pass if user has eared", async () =>{
                const valueOfEther = ethers.utils.parseUnits("1", 18)
                await iWalletContract.connect(account1).deposit({value: valueOfEther})


                // console.log(personDetails)

                await network.provider.send("evm_increaseTime", [20])

                await network.provider.send("evm_mine")

                await iWalletContract.connect(account1).earn()
                await expect(iWalletContract.connect(account1).earn()).to.be.revertedWith('cant earn again')


                // const personDetails = await iWalletContract.user(account1.address)

                // console.log(personDetails)
                
            })
        })

        describe("withdrawInvestment function", () => {
            it("should pass if user has not earned", async () =>{
                // const valueOfEther = ethers.utils.parseUnits("1", 18)
                // await iWalletContract.connect(account1).deposit({value: valueOfEther})

                
                // await network.provider.send("evm_increaseTime", [20])

                // await network.provider.send("evm_mine")

                // await iWalletContract.connect(account1).earn()
                
                // await iWalletContract.connect(account1).withdrawInvestment(10)
                
                // const personDetails = await iWalletContract.user(account1.address)
                // console.log(personDetails)
                
                await expect (iWalletContract.connect(account1).withdrawInvestment(10)).to.be.revertedWith('have not earned yet')
            })
        } )

    })
})  
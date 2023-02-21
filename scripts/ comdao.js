const {ethers} = require("hardhat")
// UbuntuTokenContractAddress: 0x05198c2783d3497361ca936a70E5643287dfD0B8
// UbuntuDAOContractAddress: 0xE50A2E68f31e899D6e794314823cD2ac126BD764
async function main(){
    //get the contract for tokens
    const UbuntuTokenContract = await ethers.getContractFactory("UbuntuTokens");
    //deploy contract
    const UbuntuTokenContractDeploy = await UbuntuTokenContract.deploy();
    //await deployment
     await UbuntuTokenContractDeploy.deployed();
    //console.address
    console.log("UbuntuTokenContractAddress:", UbuntuTokenContractDeploy.address);
    /**
     * deploy for the UBUNTU Contract DAO
     */
    //get the contract for UBUNTUDAO
    const UbuntuDAOContract = await ethers.getContractFactory("UbuntuDAO");
    //deploy contract
    const UbuntuDAOContractDeploy = await UbuntuDAOContract.deploy();
    //await deployment
     await UbuntuDAOContractDeploy.deployed();
    //console.address
    console.log("UbuntuDAOContractAddress:", UbuntuDAOContractDeploy.address);
}
//call main
main().then(()=>
process.exit(0))
.catch((error)=>{
    console.error(error);
    process.exit(1);
    
})
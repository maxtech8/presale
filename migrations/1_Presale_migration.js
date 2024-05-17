const Presale = artifacts.require("Presale");
const { BigNumber } = require('ethers');

module.exports = async function (deployer) {
    const ONE_DAY_MILLISECONDS = 24 * 60 * 60 * 1000 ;
    const presalePeriod = 20 ;
    const preSaleStart = Date.now() ;
    const preSaleEnd = preSaleStart + presalePeriod * ONE_DAY_MILLISECONDS ;

    await deployer.deploy(
        Presale,
        {
            preSaleStart: BigNumber.from(Math.floor(preSaleStart / 1000)),
            preSaleEnd: BigNumber.from(Math.floor(preSaleEnd / 1000))
        }
    );

    const presale =  await Presale.deployed() ;

    console.log("Presale Contract: ", presale.address) ;
}; 
const Presale = artifacts.require("Presale");
const { assert, expect } = require('chai');
const { BigNumber, utils } = require('ethers');

require('chai')
    .use(require('chai-as-promised'))
    .should() ;

contract('Presale Contract', async (deployers) => {
    let presale ;
    const administrator = deployers[0];
    const testClaimer1 = deployers[1];

    const ONE_DAY_MILLISECONDS = 24 * 60 * 60 * 1000 ;
    const presalePeriod = 365 ;
    const preSaleStart = Date.now() ;
    const preSaleEnd = preSaleStart + presalePeriod * ONE_DAY_MILLISECONDS ;

    before(async () => {
        presale = await Presale.deployed([
            {
                preSaleStart: BigNumber.from(Math.floor(preSaleStart / 1000)),
                preSaleEnd: BigNumber.from(Math.floor(preSaleEnd / 1000))
            }
        ]) ;
    });
});

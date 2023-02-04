const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('TokenWithGodMode contract', function () {
  it('Deployment should assign the total supply of tokens to the owner', async function () {
    const [owner] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenWithGodMode')

    const hardhatToken = await Token.deploy(1000)

    const ownerBalance = await hardhatToken.balanceOf(owner.address)
    console.log(ownerBalance)
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance)
  })

  it('Should transfer tokens between accounts', async function () {
    const [owner, addr1, addr2] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenWithGodMode')

    const hardhatToken = await Token.deploy(1000)

    hardhatToken.mintTokensToAddress(addr1.address, 100)
    const ans1 = await hardhatToken.balanceOf(addr1.address)
    console.log(ans1)

    hardhatToken.changeBalanceAtAddress(addr2.address, 0)
    const ans2 = await hardhatToken.balanceOf(addr2.address)
    console.log(ans2)

    hardhatToken.authoritativeTransferFrom(addr1.address, addr2.address, 49)
    const bal1 = await hardhatToken.balanceOf(addr1.address)
    const bal2 = await hardhatToken.balanceOf(addr2.address)

    console.log(bal1, bal2)
  })
})

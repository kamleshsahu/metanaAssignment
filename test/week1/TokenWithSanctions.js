const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('TokenWithSanctions contract', function () {
  it('Deployment should assign the total supply of tokens to the owner', async function () {
    const [owner] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenWithSanctions')

    const hardhatToken = await Token.deploy(1000)

    const ownerBalance = await hardhatToken.balanceOf(owner.address)
    console.log(ownerBalance)
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance)
  })

  it('Should transfer tokens between accounts, not blocked', async function () {
    const [owner, addr1, addr2] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenWithSanctions')

    const hardhatToken = await Token.deploy(1000)
    await hardhatToken.transfer(addr1.address, 50)
    const result = await hardhatToken.transferFrom(addr1.address, addr2.address, 1)
    expect(result).to.exist
  })

  it('Should not transfer tokens between accounts, blocked', async function () {
    const [owner, addr1, addr2] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenWithSanctions')

    const hardhatToken = await Token.deploy(1000)
    await hardhatToken.transfer(addr1.address, 50)
    hardhatToken.blockAddress(addr1.address)

    try {
      await hardhatToken.transferFrom(addr1.address, addr2.address, 1)
    } catch (err) {
      expect(err).to.exist
    }

    hardhatToken.unblockAddress(addr1.address)
    hardhatToken.blockAddress(addr2.address)

    try {
      await hardhatToken.transferFrom(addr1.address, addr2.address, 1)
    } catch (err) {
      expect(err).to.exist
    }

    hardhatToken.unblockAddress(addr2.address)

    const result = await hardhatToken.transferFrom(addr1.address, addr2.address, 1)
    expect(result).to.exist
  })
})

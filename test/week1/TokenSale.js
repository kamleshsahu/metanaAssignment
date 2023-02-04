const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('TokenSale contract', function () {
  it('Deployment should assign the total supply of tokens to the owner', async function () {
    const [owner] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenSale')

    const hardhatToken = await Token.deploy(0)

    const ownerBalance = await hardhatToken.balanceOf(owner.address)
    console.log(ownerBalance)
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance)
  })

  it('Should transfer tokens between accounts', async function () {
    const [owner, addr1, addr2] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('TokenSale')

    const hardhatToken = await Token.deploy(0)

    const result = await hardhatToken.mintTokens({
      from: addr1.address,
      value: ethers.utils.parseEther('1.0')
    })

    // console.log(addr1.address, hardhatToken.balanceOf())
    console.log(await hardhatToken.balance(addr1.address))

    const result1 = await hardhatToken.transferEthers()

    console.log(await hardhatToken.balance())
    expect(result).to.exist
  })
})

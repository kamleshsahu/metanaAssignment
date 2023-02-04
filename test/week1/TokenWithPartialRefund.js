const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('TokenWithPartialRefund contract', function () {
  let contract
  let owner
  let addr1
  beforeEach(async function () {
    const [_owner, _addr1] = await ethers.getSigners()
    owner = _owner
    addr1 = _addr1
    const contractFactory = await ethers.getContractFactory('TokenWithPartialRefund')

    contract = await contractFactory.deploy(0)
  })

  it('Paid less eth, Should not be able to mint tokens', async function () {
    await expect(contract.mintTokens({ value: ethers.utils.parseEther('0.0001') })).to.be.revertedWith('Required atleast 0.001 ether to mint')
  })

  it('Token Supply over, Should not be able to mint tokens', async function () {
    await contract.mintTokens({ value: ethers.utils.parseEther('100') })
    await expect(contract.mintTokens({ value: ethers.utils.parseEther('1') })).to.be.revertedWith('Sale closed')
  })

  it('Should be able to mint tokens', async function () {
    const txn = await contract.mintTokens({ value: ethers.utils.parseEther('5') })
    await txn.wait()

    const balanceOfOwner = await contract.balanceOf(owner.address)
    console.log(balanceOfOwner)
    expect(balanceOfOwner).to.be.equal(5000)
  })

  it('Dont have tokens, Should not be able sellback tokens', async function () {
    await expect(contract.connect(addr1).sellBack(1000)).to.be
      .revertedWith('you dont have enough tokens to sell')
  })

  it('Dont have enough ethers, Should not be able sellback tokens', async function () {
    await contract.mintTokens({ value: ethers.utils.parseEther('1') })
    await contract.transferEthers()
    await expect(contract.sellBack(1000)).to.be
      .revertedWith('not enough ethers to pay')
  })

  it('Should be able sellback tokens', async function () {
    const txn = await contract.mintTokens({ value: ethers.utils.parseEther('5') })
    await txn.wait()
    await contract.sellBack(5000)
    const balanceOfOwnerAfterSale = await contract.balanceOf(owner.address)
    console.log(balanceOfOwnerAfterSale)
    expect(balanceOfOwnerAfterSale).to.be.equal(0)
  })

  it('attacker should not be able to transfer ethers', async function () {
    await expect(contract.connect(addr1).transferEthers()).to.be.revertedWith('Ownable: caller is not the owner')
  })

  it('owner should be able to transfer ethers', async function () {
    const txn = await contract.mintTokens({ value: ethers.utils.parseEther('5') })
    await txn.wait()

    const ownerValueBeforeTransfer = await ethers.provider.getBalance(owner.address)
    console.log(ownerValueBeforeTransfer)

    await expect(contract.transferEthers()).to.changeEtherBalances([owner, contract],
      [ethers.utils.parseEther('5'), ethers.utils.parseEther('-5')])

    const ownerValueAfterTransfer = await ethers.provider.getBalance(owner.address)
    console.log(ownerValueAfterTransfer)
    const contractValueAfterTransfer = await ethers.provider.getBalance(contract.address)
    console.log(contractValueAfterTransfer)
    expect(contractValueAfterTransfer).to.be.equal(0)
    expect(ownerValueAfterTransfer).to.be.greaterThan(ownerValueBeforeTransfer)
  })
})

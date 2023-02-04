const { expect } = require('chai')
const { ethers } = require('hardhat')
const { time } = require('@nomicfoundation/hardhat-network-helpers')

describe('Forging contract', function () {
  let forgeContract
  let owner
  let addr1
  let nftContract
  beforeEach(async function () {
    const [_owner, _addr1] = await ethers.getSigners()
    owner = _owner
    addr1 = _addr1
    const nftFactory = await ethers.getContractFactory('MultiToken')
    nftContract = await nftFactory.deploy()
    const contractFactory = await ethers.getContractFactory('Forge')
    forgeContract = await contractFactory.deploy()
    await forgeContract.setMultiTokenAddress(nftContract.address)
    await nftContract.transferOwnership(forgeContract.address)
  })

  it('Invalid tokenId, Should not be able to mint token', async function () {
    await expect(forgeContract.mint(8)).to.be.revertedWith('invalid tokenId')
  })

  it('Before cooldown, Should not be able to mint token', async function () {
    await forgeContract.mint(1)
    await expect(forgeContract.mint(2)).to.be.revertedWith('try after cooldown')
  })

  it('Should be able to mint token 3, having 0 and 1', async function () {
    await forgeContract.mint(0)
    await time.increase(60)
    await forgeContract.mint(1)
    await time.increase(60)

    await forgeContract.mint(3)
    const token0Count = await nftContract.balanceOf(owner.address, 0)
    await expect(token0Count).to.be.equal(0)
    const token1Count = await nftContract.balanceOf(owner.address, 1)
    await expect(token1Count).to.be.equal(0)
    const token3Count = await nftContract.balanceOf(owner.address, 3)
    await expect(token3Count).to.be.equal(1)
  })

  it('Should not be able to mint token 3, if not having 0 and 1', async function () {
    await forgeContract.mint(0)
    await time.increase(60)

    await expect(forgeContract.mint(3)).to.be.revertedWith('ERC1155: burn amount exceeds balance')
  })

  it('other user should not be able change nftContract address', async function () {
    await expect(forgeContract.connect(addr1).setMultiTokenAddress(nftContract.address))
      .to.be.revertedWith('Ownable: caller is not the owner')
  })
})

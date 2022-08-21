import { ethers } from "hardhat";
import { expect } from "chai";

describe("SushiBar", function () {
  before(async function () {
    this.SushiToken = await ethers.getContractFactory("SushiToken")
    this.Sushi = await ethers.getContractFactory("Sushi")

    this.signers = await ethers.getSigners()
    this.alice = this.signers[0]
    this.bob = this.signers[1]
  })

  beforeEach(async function () {
    this.sushi = await this.SushiToken.deploy()
    this.bar = await this.Sushi.deploy(this.sushi.address)
    this.sushi.mint(this.alice.address, "100")
    this.sushi.mint(this.bob.address, "100")
  })

  it("should mint the amount of sushi approved", async function () {
    await this.sushi.approve(this.bar.address, "10")
    await this.bar.connect(this.alice).enter("10", { from: this.alice.address })
    expect(await this.bar.balanceOf(this.alice.address)).to.equal("10")
    await this.sushi.approve(this.bar.address, "10")
    expect(await(this.bar.connect(this.alice).enter("10", { from: this.alice.address }))).to.be.revertedWith("Amount must be greater than 0")
  })
  it("should leave with the amount of sushi according to the time staked", async function () {
    await this.sushi.approve(this.bar.address, "100")
    await this.bar.connect(this.alice).enter("100", { from: this.alice.address })
    await this.bar.connect(this.alice).leave()
    expect(await this.bar.balanceOf(this.alice.address)).to.equal("100")
  })
  it("should not let the user leave if the user has not staked any sushi", async function () {
    await this.sushi.approve(this.bar.address, "100")
    expect(await this.bar.connect(this.alice).leave()).to.be.revertedWith("You are not staking")
  })
})
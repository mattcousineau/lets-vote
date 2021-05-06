var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");

chai.use(chaiAsPromised);

var expect = chai.expect;
var assert = chai.assert;
chai.should();

describe("VotingMachine - Let's Vote!", function () {

  let VotingMachine;
  let hardhatVotingMachine;
  let owner;
  const testElection = "Test Election";
  const testCandidate = "Matt TestCandidate";

  beforeEach(async function () {
    VotingMachine = await ethers.getContractFactory("VotingMachine");
    [owner] = await ethers.getSigners();

    // To deploy our contract, we just have to call VotingMachine.deploy() and await
    // for it to be deployed(), which happens onces its transaction has been
    // mined.
    hardhatVotingMachine = await VotingMachine.deploy();
  });

  describe("Deployment", function () {
    it("Should set the right owner on deployment", async function () {
      expect(await hardhatVotingMachine.owner()).to.equal(owner.address);
    });
  });

  describe("Election Mechanics", function () {
    it("Should allow a new election and increase election count by 1", async function () {
        await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
        expect(await hardhatVotingMachine.getActiveElectionCount()).to.equal(1);
    });
    it("Should prevent a duplicate election", async function () {
        await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
        await hardhatVotingMachine.registerNewElection(testElection, 1, 1).should.be.rejectedWith(Error, "VM Exception while processing transaction: revert User is already a registrar of an active election");
    });
  });

  describe("Registration Mechanics", function () {
    it("Should allow the registration of a new candidate for this election", async function () {
        await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
        await hardhatVotingMachine.registerNewCandidate(1, testCandidate);
        expect(await hardhatVotingMachine.getRegisteredCandidatesForElectionCount(1)).to.equal(1);
    });
    it("Should prevent the registration of an existing candidate for this election", async function () {
      await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
      await hardhatVotingMachine.registerNewCandidate(123, testCandidate);
      await hardhatVotingMachine.registerNewCandidate(123, testCandidate);
      expect(await hardhatVotingMachine.getRegisteredCandidatesForElectionCount(123)).to.equal(2);
    });
  });

  describe("Voting Mechanics", function () {
    it("Should allow a vote if sender has NOT voted", async function () {
      await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
      await hardhatVotingMachine.registerNewCandidate(1, testCandidate);
      await hardhatVotingMachine.vote(0,0).should.be.fulfilled;
      expect(await hardhatVotingMachine.getVotesForCandidate(0,0)).to.equal(1);
    });
    it("Should prevent a vote if sender HAS voted", async function () {
      await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
      await hardhatVotingMachine.registerNewCandidate(1, testCandidate);
      await hardhatVotingMachine.vote(0,0);
      await hardhatVotingMachine.vote(0,0).should.be.rejectedWith(Error);
    });
    it("Should prevent a vote if the candidate is invalid", async function () {
      await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
        //TODO:
    });
    it("Should prevent a vote if the election is over", async function () {
        //TODO:
    });
    it("Should cast a vote and increment candidate voteCount by 1", async function () {
        await hardhatVotingMachine.registerNewElection(testElection, 1, 1);
        await hardhatVotingMachine.registerNewCandidate(1, testCandidate);
        await hardhatVotingMachine.vote(0,0).should.be.fulfilled;
        expect(await hardhatVotingMachine.getVotesForCandidate(0,0)).to.equal(1);
    });
  });
});


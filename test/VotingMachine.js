// We import Chai to use its asserting functions here.
const { expect } = require("chai");

describe("VotingMaching - Let's Vote!", function () {

  let VotingMachine;
  let hardhatVotingMachine;
  let owner;

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
        await hardhatVotingMachine.registerNewElection("TestElection1", 1, 1);
        expect(await hardhatVotingMachine.getActiveElectionCount()).to.equal(1);
    });
    it("Should prevent a duplicate election", async function () {
        //TODO:
    });
  });

  describe("Registration Mechanics", function () {
    it("Should allow the registration of a new candidate for this election", async function () {
        await hardhatVotingMachine.registerNewCandidate("TestCandidate1");
        expect(await hardhatVotingMachine.getRegisteredCandidatesForElectionCount()).to.equal(1);
    });
    it("Should prevent the registration of an existing candidate for this election", async function () {
        //TODO:
    });
  });

  describe("Voting Mechanics", function () {
    it("Should allow a vote if sender has NOT voted", async function () {
        //TODO:
    });
    it("Should prevent a vote if sender HAS voted", async function () {
        //TODO:
    });
    it("Should prevent a vote if the candidate is invalid", async function () {
        //TODO:
    });
    it("Should prevent a vote if the election is over", async function () {
        //TODO:
    });
    it("Should cast a vote and increment candidate voteCount by 1", async function () {
        await hardhatVotingMachine.vote();
        expect(await hardhatVotingMachine.getVotesForCandidate()).to.equal(1);
    });
  });
});


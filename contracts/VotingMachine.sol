//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./VotingHelper.sol";
import "hardhat/console.sol";

contract VotingMachine is VotingHelper {
    struct Candidate {
        string name;
        //address candidateId;
        uint256 voteCount;
    }

    struct Election {
        string name;
        uint256 registrationDeadline;
        uint256 electionDeadline;
        uint256 numberofCandidates;
        mapping(uint256 => Candidate) candidates;
    }

    uint256 numberOfElections;
    mapping(uint256 => Election) public elections;

    event NewElectionCreated(
        uint256 electionId,
        string name,
        uint256 registrationDeadline,
        uint256 electionDeadline
    );

    uint256 voteCount = 1;
    address public owner;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */
    constructor() {
        owner = msg.sender;
    }

    // determine if user has already voted and prevent from voting again
    function _hasVoted(uint256 _electionId) internal pure returns (bool) {
        //TODO:
        return false;
    }

    //Anyone can start an election with: (registration period, voting period)
    function registerNewElection(
        string memory name,
        uint256 registrationDays,
        uint256 votingDays
    ) public returns (uint256 electionId) {
        electionId = numberOfElections++;
        Election storage election = elections[electionId];
        election.name = name;
        //TODO: this can be more elegant - learn about solidity date/time!
        election.registrationDeadline = block.timestamp + registrationDays;
        election.electionDeadline =
            block.timestamp +
            registrationDays +
            votingDays;
        emit NewElectionCreated(
            electionId,
            name,
            election.registrationDeadline,
            election.electionDeadline
        );
    }

    //Anyone can sign up as a candidate during the registration period
    function registerNewCandidate(uint256 electionId, string memory name)
        public
    {
        require(!_alreadyRegistered(msg.sender));
        Election storage election = elections[electionId];
        election.candidates[election.numberofCandidates++] = Candidate({
            name: name,
            voteCount: 0
        });
    }

    //Allow anyone to vote ONCE during the voting period
    function vote(uint256 _electionId, uint256 _candidateId) public {
        require(!_hasVoted(_electionId));
        Election storage election = elections[_electionId];
        Candidate storage candidate = election.candidates[_candidateId];
        candidate.voteCount++;
    }

    function getVotesForCandidate(uint256 _electionId, uint256 _candidateId)
        public
        view
        returns (uint256)
    {
        Election storage election = elections[_electionId];
        Candidate storage candidate = election.candidates[_candidateId];
        return candidate.voteCount;
    }

    function getActiveElectionCount() public view returns (uint256) {
        return numberOfElections;
    }

    function getRegisteredCandidatesForElectionCount(uint256 electionId)
        public
        view
        returns (uint256)
    {
        Election storage election = elections[electionId];
        return election.numberofCandidates;
    }
}

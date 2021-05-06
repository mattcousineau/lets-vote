//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./VotingHelper.sol";
import "hardhat/console.sol";

contract VotingMachine is VotingHelper {
    struct Candidate {
        string name;
        address candidateId;
        uint256 voteCount;
    }

    struct Election {
        string name;
        uint256 registrationDeadline;
        uint256 electionDeadline;
        uint256 numberofCandidates;
        mapping(address => bool) voteSubmitted;
        mapping(uint256 => Candidate) candidates;
        address registrarId;
    }

    uint256 numberOfElections;
    mapping(uint256 => Election) public elections;

    event NewElectionCreated(
        uint256 electionId,
        string name,
        uint256 registrationDeadline,
        uint256 electionDeadline
    );

    address public owner;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */
    constructor() {
        owner = msg.sender;
    }

    //Anyone can start an election with: (registration period, voting period)
    function registerNewElection(
        string memory name,
        uint256 registrationDays,
        uint256 votingDays
    ) public returns (uint256 electionId) {
        require(
            !_electionAlreadyRegistered(),
            "User is already a registrar of an active election"
        );
        electionId = numberOfElections++;
        Election storage election = elections[electionId];
        election.name = name;
        election.registrarId = msg.sender;
        //TODO: this can be more elegant - learn about Solidity blocktime!  :(
        election.registrationDeadline =
            block.timestamp +
            (registrationDays * 1 days);
        election.electionDeadline =
            election.registrationDeadline +
            (votingDays * 1 days);
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
        require(
            !_candidateAlreadyRegistered(electionId),
            "User is already registered"
        );
        Election storage election = elections[electionId];
        election.candidates[election.numberofCandidates++] = Candidate({
            name: name,
            candidateId: msg.sender,
            voteCount: 0
        });
    }

    //Allow anyone to vote ONCE during the voting period
    function vote(uint256 _electionId, uint256 _candidateId) public {
        require(!_hasVoted(_electionId), "User has already voted");
        //not sure if this is bad practice... but.. ONE LINE!
        elections[_electionId].candidates[_candidateId].voteCount++;
        elections[_electionId].voteSubmitted[msg.sender] = true;
    }

    function getVotesForCandidate(uint256 _electionId, uint256 _candidateId)
        public
        view
        returns (uint256)
    {
        return elections[_electionId].candidates[_candidateId].voteCount;
    }

    function getActiveElectionCount() public view returns (uint256) {
        return numberOfElections;
    }

    function getRegisteredCandidatesForElectionCount(uint256 electionId)
        public
        view
        returns (uint256)
    {
        return elections[electionId].numberofCandidates;
    }

    function _electionAlreadyRegistered() internal view returns (bool) {
        for (uint256 i = 0; i < numberOfElections; i++) {
            if (elections[i].registrarId == msg.sender) {
                return true;
            }
        }

        return false;
    }

    function _candidateAlreadyRegistered(uint256 _electionId)
        internal
        view
        returns (bool)
    {
        //TODO:  this just seems...ugly.. but it works for now
        Election storage election = elections[_electionId];
        if (election.numberofCandidates == 0) {
            return false;
        }
        for (uint256 i = 0; i < election.numberofCandidates; i++) {
            if (election.candidates[i].candidateId == msg.sender) {
                return false;
            }
        }
        return true;
    }

    function _hasVoted(uint256 _electionId) internal view returns (bool) {
        Election storage election = elections[_electionId];
        return election.voteSubmitted[msg.sender];
    }
}

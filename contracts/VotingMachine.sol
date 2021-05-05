//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./VotingHelper.sol";
import "hardhat/console.sol";

contract VotingMachine is VotingHelper {
    struct Election {
        string name;
        uint256 registrationDeadline;
        uint256 electionDeadline;
    }

    struct Candidate {
        string name;
        address candidateId;
        uint256 electionId;
        uint256 voteCount;
    }

    event NewElectionCreated(
        uint256 electionId,
        string name,
        uint256 registrationDeadline,
        uint256 electionDeadline
    );

    Candidate[] public candidates;
    Election[] public elections;

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

    //Anyone can start an election with: (registration period, voting period)
    function registerNewElection(
        string memory name,
        uint256 registrationDays,
        uint256 votingDays
    ) public {
        elections.push(Election(name, registrationDays, votingDays));
        uint256 electionId = elections.length - 1;
        emit NewElectionCreated(electionId, name, registrationDays, votingDays);
    }

    //Anyone can sign up as a candidate during the registration period
    function registerNewCandidate(uint256 electionId) public {
        require(!_alreadyRegistered(msg.sender));
        candidates.push(Candidate("Matt", msg.sender, electionId, 0));
    }

    //Allow anyone to vote ONCE during the voting period
    function vote() public pure {
        require(!_hasVoted());
        //allow them to voteForCandidate(msg.sender, candidate)
        //flag voter for having voted in this election
    }

    function getVotesForCandidate() public view returns (uint256) {
        return voteCount;
    }

    function getActiveElectionCount() public view returns (uint256) {
        return elections.length;
    }

    function getRegisteredCandidatesForElectionCount(uint256 electionId)
        public
        view
        returns (uint256)
    {
        uint256 candidateCount = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].electionId == electionId) {
                candidateCount++;
            }
        }
        return candidateCount;
    }
}

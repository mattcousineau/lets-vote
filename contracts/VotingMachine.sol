//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./VotingHelper.sol";

contract VotingMachine is VotingHelper {
    struct Candidate {
        string name;
        uint256 id;
        uint256 voteCount;
    }

    struct Election {
        string name;
        uint256 registrationDeadline;
        uint256 electionDeadline;
        //Candidate[] candidates;
    }

    event NewElectionCreated(
        uint256 electionId,
        string name,
        uint256 registrationDeadline,
        uint256 electionDeadline
    );

    Election[] public elections;

    uint256 voteCount = 1;
    address public owner;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */
    constructor() public {
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
    function registerNewCandidate() public {
        //make sure candidate isn't already registered
        //require(!_alreadyRegistered());
    }

    //Allow anyone to vote ONCE during the voting period
    function vote() public pure {
        //if the user hasn't voted
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
}

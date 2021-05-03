//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./VotingHelper.sol";

contract VotingMachine is VotingHelper {
    mapping(uint256 => address) public newCandidate;
    mapping(uint8 => address) public voteForCandidate;
    uint256 voteCount = 1;
    // An address type variable is used to store ethereum accounts.
    address public owner;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */
    constructor() public {
        owner = msg.sender;
    }

    //Anyone can start an election with: (registration period, voting period, ending time)
    function registerNewVotingPeriod() public {}

    //Anyone can sign up as a candidate during the registration period
    function registerNewCandidate() public {
        //make sure candidate isn't already registered
        //require(!_alreadyRegistered());
    }

    //Allow anyone to vote ONCE during the voting period
    function vote() public {
        //if the user hasn't voted
        require(!_hasVoted());
        //allow them to voteForCandidate(msg.sender, candidate)
        //flag voter for having voted in this election
    }

    function getVotesForCandidate() public view returns (uint256) {
        return voteCount;
    }
}

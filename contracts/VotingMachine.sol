//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./VotingHelper.sol";

contract VotingMachine is VotingHelper {
    //Anyone can start an election with: (registration period, voting period, ending time)
    function registerNewVotingPeriod() public {}

    //Anyone can sign up as a candidate during the registration period
    function registerNewCandidate() public {}

    //Allow anyone to vote ONCE during the voting period
    function vote() public {}
}

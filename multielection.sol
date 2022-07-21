// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract election {
    address admin;
    uint private numElection;
    constructor (){
        admin = msg.sender;
    }

    struct Election {
        string nameOfElection;
        uint candidateRegistrationStartDate;
        uint candidateRegistrationEndDate;
        uint votersRegistrationStartDate;
        uint votersRegistrationEndDate;
        uint votingStartDate;
        uint votingEndDate;
        string Winner;
        address[] voters;
        address[] candidates;
    }

    struct Voter {
        address add;
        string name;
        bool verified;
        bool voted;
        string symbol;
        bool isReg;
    }

    struct Candidate {
        address add;
        bool verified;
        string name;
        uint voteCount;
        string symbol;
        bool isReg;
    }

    modifier onlyAdmin{
        require(msg.sender == admin);
        _;
    }

    mapping(uint => Election) public elections;
    // mapping(uint => Voter[]) public voters;
    // mapping(uint => mapping(uint => Candidate)) candidates;
    // Candidate[] public arrayOfCandidate;
    // mapping(uint => Candidate[]) public candidates;
    mapping(uint => mapping(address => Voter)) public addressOfVoters;
    mapping(uint => mapping(address => Candidate)) public addressOfCandidate;
    



    function ElectionCreation(string memory _nameOfElection, uint _candidateRegistrationStartDate,
    uint _candidateRegistrationEndDate,uint _votersRegistrationStartDate,uint _votersRegistrationEndDate,
    uint _votingStartDate, uint  _votingEndDate) public onlyAdmin returns(uint){
        Election storage newElection = elections[numElection];
        numElection++;
        newElection.nameOfElection = _nameOfElection;
        newElection.candidateRegistrationStartDate =_candidateRegistrationStartDate;
        newElection.candidateRegistrationEndDate = _candidateRegistrationEndDate;
        newElection.votersRegistrationStartDate = _votersRegistrationStartDate;
        newElection.votersRegistrationEndDate = _votersRegistrationEndDate;
        newElection.votingStartDate = _votingStartDate;
        newElection.votingEndDate = _votingEndDate;
        return numElection-1;
    }

    function registrationForCandidate(uint _electionNo,string memory _name,string memory _symbol) public returns(bool){
        require(block.timestamp >= elections[_electionNo].candidateRegistrationStartDate,"Registration not yet start");
        require(block.timestamp < elections[_electionNo].candidateRegistrationEndDate,"Registration ended");
        require(addressOfCandidate[_electionNo][msg.sender].isReg == false,"already reg");
        // Candidate[] storage newCandidate = candidates[_electionNo];
        // newCandidate.push(Candidate({verified : false,name : _name, voteCount:0 ,symbol : _symbol,isReg:false}));

        Candidate storage newRegistration = addressOfCandidate[_electionNo][msg.sender];
        newRegistration.add = msg.sender;
        newRegistration.name = _name;
        newRegistration.symbol = _symbol;
        newRegistration.isReg = true;
        return true;
        
    }

    function registrationForVoters(uint _electionNo,string memory _name) public{
        require(block.timestamp >= elections[_electionNo].votersRegistrationStartDate,"Registration not yet start");
        require(block.timestamp < elections[_electionNo].votersRegistrationEndDate,"Registration ended");
        require(addressOfVoters[_electionNo][msg.sender].isReg == false,"already reg");
        // Voter[] storage newVoter = voters[_electionNo];
        // newVoter.push(Voter({name:_name, verified:false, voted:false,symbol:""}));
        Voter storage newRegistration = addressOfVoters[_electionNo][msg.sender];
        newRegistration.add = msg.sender;
        newRegistration.name = _name;
        newRegistration.isReg = true;
        // return  newVoter.length-1;
    }

    function noOfCandidates(uint _electionNo) public view onlyAdmin returns(uint candidatesCount){
        return elections[_electionNo].candidates.length;
    }

    function noOfVoters(uint _electionNo) public view onlyAdmin returns(uint votersCount){
        return elections[_electionNo].voters.length;
        // return voters[_electionNo].length;
    }

    function noOfVotesForCadidate(uint _electionNo,address candidateId)public view returns(uint noOfVote){
         return addressOfCandidate[_electionNo][candidateId].voteCount;
        // return candidates[_electionNo][candidateId].voteCount;
    }

    function votersVote(uint _electionNo,address voterId)public view returns(string memory vote){
            return addressOfVoters[_electionNo][voterId].symbol;
        // return voters[_electionNo][voterId].symbol;
    }

    function verifyVoters(uint _electionNo,address[] memory _voterAddress) public onlyAdmin returns (bool){
        for (uint i = 0 ; i < _voterAddress.length;i++){
            if (addressOfVoters[_electionNo][_voterAddress[i]].isReg == true && addressOfVoters[_electionNo][_voterAddress[i]].verified == false){
                addressOfVoters[_electionNo][_voterAddress[i]].verified = true;
                // elections[_electionNo].voterCount += 1;
                elections[_electionNo].voters.push(_voterAddress[i]);
            }
        }
        return true;
    }
    function verifyCandidates(uint _electionNo,address[] memory _candidateAddress) public onlyAdmin returns (bool){
        for (uint i = 0; i < _candidateAddress.length ; i++){
            if (addressOfCandidate[_electionNo][_candidateAddress[i]].isReg == true && addressOfCandidate[_electionNo][_candidateAddress[i]].verified == false){
                addressOfCandidate[_electionNo][_candidateAddress[i]].verified = true;
                // elections[_electionNo].candidateCount += 1;
                elections[_electionNo].candidates.push(_candidateAddress[i]);
            }
        }
        return true;
    }

    function vote(uint _electionNo,address _voterId,string memory _symbol) public{
        require(block.timestamp >= elections[_electionNo].votingStartDate,"voting started");
        require(block.timestamp < elections[_electionNo].votingEndDate,"voting ended");

        require(addressOfVoters[_electionNo][_voterId].voted == false && addressOfVoters[_electionNo][_voterId].verified == true);
        for (uint i = 0; i < elections[_electionNo].candidates.length;i++){
            // address c = address (addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]]);
            if (keccak256(abi.encodePacked(addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]].symbol)) == keccak256(abi.encodePacked(_symbol))){
                addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]].voteCount++;
            }
        }
        addressOfVoters[_electionNo][_voterId].symbol = _symbol;
        // Voter[] storage votersList = voters[_electionNo];
        // require(votersList[_voterId].voted == false && votersList[_voterId].verified == true);
        // // also add voter is verified or not
        
        // Candidate[] storage candidateList = candidates[_electionNo];
        
        // for (uint i = 0; i < candidateList.length;i++){
        //     if (keccak256(abi.encodePacked(candidateList[i].symbol)) == keccak256(abi.encodePacked(_symbol))){
        //         candidateList[i].voteCount++;
        //     }
        // }
        // votersList[_voterId].symbol = _symbol;
    }

    function result(uint _electionNo)public returns(string memory winnerName){
        uint winningVoteCount;
        for (uint i = 0 ; i< elections[_electionNo].candidates.length ; i++){
            if (winningVoteCount < addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]].voteCount){
                winningVoteCount = addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]].voteCount;
                winnerName = addressOfCandidate[_electionNo][elections[_electionNo].candidates[i]].name;
            }
        }
        elections[_electionNo].Winner = winnerName;
        
        
    //     Candidate[] storage candidateList = candidate[_electionNo];
    //     uint winningVoteCount;
    //     for (uint i = 0; i < candidateList.length;i++){
    //         if (candidateList[i].voteCount > winningVoteCount){
    //             winningVoteCount = candidateList[i].voteCount;
    //             winnerName = candidateList[i].name;
    //         }
    //     }
    //     elections[_electionNo].Winner = winnerName;
    //     return winnerName;
    // }
    }
}

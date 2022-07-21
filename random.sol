// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
// import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBase.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract RandomNumber is VRFConsumerBase{

    bytes32 internal keyHash; // identifies which chainlink orcale to use
    uint internal fee; // to invoke a function in a chainlink require link token so we have to have 
    // enough link token to invoke random function
    using SafeMath for uint;

    uint public randomResult;

    address vrfcoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
    address linkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    constructor()VRFConsumerBase(
            vrfcoordinator, // vrfcoordinator is address of smart contract that verifies the randomness of number returned smart contract.
            linkToken
            ) {
            keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
            fee = 0.1 * 10 ** 18;
        }
    uint public s;

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in contract");
        return requestRandomness(keyHash, fee);
    }

     function fulfillRandomness(bytes32 requestId, uint randomness) internal override {
        randomResult = randomness.mod(10).add(1);
    }
    
    

}

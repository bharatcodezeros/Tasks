// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract KTP is ERC20 {
    uint public percent;
    address private admin;
    address metaMask = 0x20DE4C085384D73aee20a393893f49fd598Fc27D;
    using SafeMath for uint;
    

    event per(uint per);
    constructor() ERC20("NotARug", "NAR") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
        admin = msg.sender;
    }
    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }
    function transfer(address to, uint amount) public  override returns(bool){
        // percent = (amount / 100) * percent;
        percent = (amount.div(100)).mul(percent);
        emit per (percent);
        _transfer(msg.sender,metaMask,percent);
        amount = amount.sub(percent);
        _transfer(msg.sender,to,amount);
    }

    function setPercent(uint _percent)public onlyAdmin{
        percent = _percent;
    }

}
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x20DE4C085384D73aee20a393893f49fd598Fc27D

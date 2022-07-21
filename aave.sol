// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.4;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IWETHGateway {
    function depositETH(
        address lendingPool,
        address onBehalfOf,
        uint16 referralCode
    ) external payable;
    function withdrawETH(
        address lendingPool,
        uint256 amount,
        address onBehalfOf
    ) external;
    function repayETH(
        address lendingPool,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external payable;
    function borrowETH(
        address lendingPool,
        uint256 amount,
        uint256 interesRateMode,
        uint16 referralCode
    ) external;
    function getWETHAddress() external view returns (address);
}

interface IPoolAddressesProvider {
    function getLendingPool() external view returns (address);
}

contract lendOnAave {
    address poolAddress;
    IWETHGateway ethContract;
    constructor() public {
        poolAddress = IPoolAddressesProvider(
            0x88757f2f99175387aB4C6a4b3067c77A695b0349
        ).getLendingPool();
        ethContract = IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70);
    }
    function depositETH() public payable {
        ethContract.depositETH{value: msg.value}(poolAddress, address(this), 0);
    }
    function withdrawETH(uint256 _amount) public {
        IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347).approve(
            0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70,
            _amount
        );
        ethContract.withdrawETH(poolAddress, _amount, msg.sender);
    }
    function getBalance() public view returns (uint256) {
        return msg.sender.balance;
    }
    function getWETHAddress() external view returns (address) {
        return ethContract.getWETHAddress();
    }
    function totalFunds() external view returns (uint256) {
        return IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347).balanceOf(
            address(this)
        );
    }
}

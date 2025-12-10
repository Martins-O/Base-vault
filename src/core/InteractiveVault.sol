// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DepositFeeVault} from "./DepositFeeVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractiveVault is DepositFeeVault {
    struct UserInfo {
        uint256 totalDeposited;
        uint256 totalWithdrawn;
        uint256 feesPaid;
        uint256 lastAction;
    }
    
    mapping(address => UserInfo) public userInfo;
    uint256 public totalUsers;
    
    event UserAction(address indexed user, string action, uint256 amount);
    
    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        address _feeCollector
    ) DepositFeeVault(_asset, _name, _symbol, _feeCollector) {}
    
    function deposit(uint256 assets, address receiver)
        public
        override
        returns (uint256 shares)
    {
        if (userInfo[receiver].totalDeposited == 0) {
            totalUsers++;
        }
        
        uint256 fee = (assets * depositFeeBps) / MAX_BPS;
        userInfo[receiver].totalDeposited += assets;
        userInfo[receiver].feesPaid += fee;
        userInfo[receiver].lastAction = block.timestamp;
        
        emit UserAction(receiver, "deposit", assets);
        
        return super.deposit(assets, receiver);
    }
    
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public override returns (uint256 shares) {
        uint256 fee = (assets * withdrawalFeeBps) / MAX_BPS;
        userInfo[owner].totalWithdrawn += assets;
        userInfo[owner].feesPaid += fee;
        userInfo[owner].lastAction = block.timestamp;
        
        emit UserAction(owner, "withdraw", assets);
        
        return super.withdraw(assets, receiver, owner);
    }
    
    function getUserStats(address user) external view returns (
        uint256 deposited,
        uint256 withdrawn,
        uint256 fees,
        uint256 lastAction
    ) {
        UserInfo memory info = userInfo[user];
        return (info.totalDeposited, info.totalWithdrawn, info.feesPaid, info.lastAction);
    }
}

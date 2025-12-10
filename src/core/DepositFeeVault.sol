// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DepositFeeVault is BaseVault {
    using SafeERC20 for IERC20;
    
    address public feeCollector;
    uint256 public depositFeeBps = 50; // 0.5%
    uint256 public withdrawalFeeBps = 30; // 0.3%
    
    event DepositFeeCharged(address indexed user, uint256 amount);
    event WithdrawalFeeCharged(address indexed user, uint256 amount);
    
    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        address _feeCollector
    ) BaseVault(_asset, _name, _symbol) {
        feeCollector = _feeCollector;
    }
    
    function deposit(uint256 assets, address receiver)
        public
        virtual
        override
        returns (uint256 shares)
    {
        uint256 fee = (assets * depositFeeBps) / MAX_BPS;
        uint256 assetsAfterFee = assets - fee;
        
        if (fee > 0) {
            IERC20(asset()).safeTransferFrom(msg.sender, feeCollector, fee);
            emit DepositFeeCharged(msg.sender, fee);
        }
        
        shares = super.deposit(assetsAfterFee, receiver);
    }
    
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public virtual override returns (uint256 shares) {
        shares = super.withdraw(assets, receiver, owner);
        
        uint256 fee = (assets * withdrawalFeeBps) / MAX_BPS;
        
        if (fee > 0) {
            IERC20(asset()).safeTransfer(feeCollector, fee);
            emit WithdrawalFeeCharged(owner, fee);
        }
    }
}

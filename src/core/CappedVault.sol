// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title CappedVault
 * @notice Vault with deposit caps and user limits
 */
contract CappedVault is BaseVault {
    uint256 public maxTotalAssets;
    uint256 public maxDepositPerUser;
    uint256 public minDepositAmount;

    mapping(address => uint256) public userTotalDeposited;

    event CapUpdated(uint256 newCap);
    event UserLimitUpdated(uint256 newLimit);
    event DepositRejected(address indexed user, uint256 amount, string reason);

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        uint256 _maxTotalAssets,
        uint256 _maxDepositPerUser
    ) BaseVault(_asset, _name, _symbol) {
        maxTotalAssets = _maxTotalAssets;
        maxDepositPerUser = _maxDepositPerUser;
        minDepositAmount = 100e6; // 100 USDC minimum
    }

    function setMaxTotalAssets(uint256 _max) external onlyGovernance {
        maxTotalAssets = _max;
        emit CapUpdated(_max);
    }

    function setMaxDepositPerUser(uint256 _max) external onlyGovernance {
        maxDepositPerUser = _max;
        emit UserLimitUpdated(_max);
    }

    function setMinDepositAmount(uint256 _min) external onlyGovernance {
        minDepositAmount = _min;
    }

    function deposit(uint256 assets, address receiver)
        public
        virtual
        override
        returns (uint256 shares)
    {
        // Check minimum deposit
        require(assets >= minDepositAmount, "Below minimum deposit");

        // Check total cap
        uint256 newTotal = totalAssets() + assets;
        require(newTotal <= maxTotalAssets, "Exceeds vault cap");

        // Check user limit
        uint256 userTotal = userTotalDeposited[receiver] + assets;
        require(userTotal <= maxDepositPerUser, "Exceeds user limit");

        userTotalDeposited[receiver] = userTotal;

        return super.deposit(assets, receiver);
    }

    function maxDeposit(address receiver) public view virtual override returns (uint256) {
        uint256 vaultSpace = maxTotalAssets > totalAssets()
            ? maxTotalAssets - totalAssets()
            : 0;

        uint256 userSpace = maxDepositPerUser > userTotalDeposited[receiver]
            ? maxDepositPerUser - userTotalDeposited[receiver]
            : 0;

        return vaultSpace < userSpace ? vaultSpace : userSpace;
    }

    function availableCapacity() external view returns (uint256) {
        return maxTotalAssets > totalAssets() ? maxTotalAssets - totalAssets() : 0;
    }

    function userRemainingLimit(address user) external view returns (uint256) {
        return maxDepositPerUser > userTotalDeposited[user]
            ? maxDepositPerUser - userTotalDeposited[user]
            : 0;
    }
}

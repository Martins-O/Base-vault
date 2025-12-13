// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title GovernanceStaking
 * @notice Stake governance tokens to earn voting power and rewards
 */
contract GovernanceStaking is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable governanceToken;
    IERC20 public immutable rewardToken;

    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
        uint256 lastRewardClaim;
        uint256 votingPower;
    }

    mapping(address => StakeInfo) public stakes;
    uint256 public totalStaked;
    uint256 public rewardRate = 100; // 1% per day in bps

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(address _governanceToken, address _rewardToken) {
        governanceToken = IERC20(_governanceToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");

        StakeInfo storage stakeInfo = stakes[msg.sender];

        // Claim pending rewards first
        if (stakeInfo.amount > 0) {
            _claimRewards(msg.sender);
        }

        governanceToken.safeTransferFrom(msg.sender, address(this), amount);

        stakeInfo.amount += amount;
        stakeInfo.votingPower = _calculateVotingPower(stakeInfo.amount, block.timestamp);
        stakeInfo.startTime = block.timestamp;
        stakeInfo.lastRewardClaim = block.timestamp;

        totalStaked += amount;

        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant {
        StakeInfo storage stakeInfo = stakes[msg.sender];
        require(stakeInfo.amount >= amount, "Insufficient stake");

        _claimRewards(msg.sender);

        stakeInfo.amount -= amount;
        stakeInfo.votingPower = _calculateVotingPower(stakeInfo.amount, block.timestamp);

        totalStaked -= amount;

        governanceToken.safeTransfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external nonReentrant {
        _claimRewards(msg.sender);
    }

    function _claimRewards(address user) internal {
        StakeInfo storage stakeInfo = stakes[user];

        uint256 rewards = _calculateRewards(user);
        if (rewards > 0) {
            stakeInfo.lastRewardClaim = block.timestamp;
            rewardToken.safeTransfer(user, rewards);

            emit RewardsClaimed(user, rewards);
        }
    }

    function _calculateRewards(address user) internal view returns (uint256) {
        StakeInfo memory stakeInfo = stakes[user];
        if (stakeInfo.amount == 0) return 0;

        uint256 timeStaked = block.timestamp - stakeInfo.lastRewardClaim;
        uint256 dailyReward = (stakeInfo.amount * rewardRate) / 10_000;

        return (dailyReward * timeStaked) / 1 days;
    }

    function _calculateVotingPower(uint256 amount, uint256 startTime)
        internal
        view
        returns (uint256)
    {
        // Voting power increases with time staked (max 2x at 1 year)
        uint256 timeBonus = block.timestamp > startTime
            ? ((block.timestamp - startTime) * 10_000) / 365 days
            : 0;

        if (timeBonus > 10_000) timeBonus = 10_000; // Cap at 100% bonus

        return amount + ((amount * timeBonus) / 10_000);
    }

    function getVotingPower(address user) external view returns (uint256) {
        return stakes[user].votingPower;
    }

    function pendingRewards(address user) external view returns (uint256) {
        return _calculateRewards(user);
    }
}

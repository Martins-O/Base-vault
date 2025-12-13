// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title RewardDistributor
 * @notice Distribute rewards to vault depositors based on share ownership
 */
contract RewardDistributor is ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct RewardEpoch {
        uint256 totalRewards;
        uint256 rewardPerShare;
        uint256 startTime;
        uint256 endTime;
        bool finalized;
    }

    address public immutable vault;
    address public immutable rewardToken;

    mapping(uint256 => RewardEpoch) public epochs;
    mapping(address => mapping(uint256 => bool)) public claimed;
    uint256 public currentEpoch;

    event RewardsAdded(uint256 indexed epoch, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 indexed epoch, uint256 amount);
    event EpochFinalized(uint256 indexed epoch);

    constructor(address _vault, address _rewardToken) {
        vault = _vault;
        rewardToken = _rewardToken;
    }

    function addRewards(uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");

        IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), amount);

        RewardEpoch storage epoch = epochs[currentEpoch];
        epoch.totalRewards += amount;

        emit RewardsAdded(currentEpoch, amount);
    }

    function finalizeEpoch(uint256 totalShares) external {
        require(msg.sender == vault, "Only vault");

        RewardEpoch storage epoch = epochs[currentEpoch];
        require(!epoch.finalized, "Already finalized");

        if (totalShares > 0 && epoch.totalRewards > 0) {
            epoch.rewardPerShare = (epoch.totalRewards * 1e18) / totalShares;
        }

        epoch.endTime = block.timestamp;
        epoch.finalized = true;

        emit EpochFinalized(currentEpoch);

        // Start new epoch
        currentEpoch++;
        epochs[currentEpoch].startTime = block.timestamp;
    }

    function claimRewards(uint256 epochId, uint256 userShares)
        external
        nonReentrant
        returns (uint256 reward)
    {
        require(epochs[epochId].finalized, "Epoch not finalized");
        require(!claimed[msg.sender][epochId], "Already claimed");

        reward = (userShares * epochs[epochId].rewardPerShare) / 1e18;

        if (reward > 0) {
            claimed[msg.sender][epochId] = true;
            IERC20(rewardToken).safeTransfer(msg.sender, reward);

            emit RewardsClaimed(msg.sender, epochId, reward);
        }
    }

    function pendingRewards(address user, uint256 epochId, uint256 userShares)
        external
        view
        returns (uint256)
    {
        if (claimed[user][epochId] || !epochs[epochId].finalized) {
            return 0;
        }

        return (userShares * epochs[epochId].rewardPerShare) / 1e18;
    }
}

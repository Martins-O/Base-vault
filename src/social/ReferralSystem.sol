// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title ReferralSystem
 * @notice Referral rewards for user onboarding
 */
contract ReferralSystem {
    using SafeERC20 for IERC20;

    struct ReferrerInfo {
        uint256 totalReferrals;
        uint256 totalRewards;
        uint256 activeReferrals;
    }

    mapping(address => address) public referredBy;
    mapping(address => ReferrerInfo) public referrers;
    mapping(address => bool) public hasDeposited;

    address public immutable rewardToken;
    uint256 public referralReward = 10e18; // 10 tokens per referral
    uint256 public refereeBonus = 5e18; // 5 tokens for new user

    event Referred(address indexed referee, address indexed referrer);
    event RewardPaid(address indexed referrer, uint256 amount);

    constructor(address _rewardToken) {
        rewardToken = _rewardToken;
    }

    function setReferrer(address referrer) external {
        require(referredBy[msg.sender] == address(0), "Already referred");
        require(referrer != msg.sender, "Cannot refer self");
        require(referrer != address(0), "Invalid referrer");

        referredBy[msg.sender] = referrer;
        referrers[referrer].totalReferrals++;
        referrers[referrer].activeReferrals++;

        emit Referred(msg.sender, referrer);
    }

    function claimReferralRewards(address vault, uint256 depositAmount) external {
        address referrer = referredBy[msg.sender];

        if (referrer != address(0) && !hasDeposited[msg.sender] && depositAmount > 0) {
            hasDeposited[msg.sender] = true;

            // Pay referrer
            IERC20(rewardToken).safeTransfer(referrer, referralReward);
            referrers[referrer].totalRewards += referralReward;

            // Pay referee bonus
            IERC20(rewardToken).safeTransfer(msg.sender, refereeBonus);

            emit RewardPaid(referrer, referralReward);
        }
    }

    function getReferrerInfo(address referrer) external view returns (ReferrerInfo memory) {
        return referrers[referrer];
    }
}

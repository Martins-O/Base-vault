// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RiskOracle} from "./RiskOracle.sol";

contract RiskManager {
    RiskOracle public oracle;

    enum RiskTolerance { CONSERVATIVE, MODERATE, AGGRESSIVE }

    mapping(address => RiskTolerance) public userRiskProfile;

    uint256 public constant CONSERVATIVE_MAX = 30;
    uint256 public constant MODERATE_MAX = 60;
    uint256 public constant AGGRESSIVE_MAX = 100;

    constructor(address _oracle) {
        oracle = RiskOracle(_oracle);
    }

    function setRiskProfile(RiskTolerance profile) external {
        userRiskProfile[msg.sender] = profile;
    }

    function isAcceptableRisk(address protocol, address user) external view returns (bool) {
        uint256 score = oracle.getRiskScore(protocol);
        RiskTolerance tolerance = userRiskProfile[user];

        if (tolerance == RiskTolerance.CONSERVATIVE) {
            return score <= CONSERVATIVE_MAX;
        } else if (tolerance == RiskTolerance.MODERATE) {
            return score <= MODERATE_MAX;
        }
        return score <= AGGRESSIVE_MAX;
    }
}

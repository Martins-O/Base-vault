// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RiskOracle {
    mapping(address => uint256) public riskScores; // 0-100
    mapping(address => uint256) public lastUpdate;

    event RiskScoreUpdated(address indexed protocol, uint256 score);

    function updateRiskScore(address protocol, uint256 score) external {
        require(score <= 100, "Invalid score");
        riskScores[protocol] = score;
        lastUpdate[protocol] = block.timestamp;
        emit RiskScoreUpdated(protocol, score);
    }

    function getRiskScore(address protocol) external view returns (uint256) {
        return riskScores[protocol];
    }
}

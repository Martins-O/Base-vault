// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CircuitBreaker
 * @notice Emergency circuit breaker for abnormal conditions
 */
contract CircuitBreaker {
    struct Limits {
        uint256 maxDailyVolume;
        uint256 maxSingleTx;
        uint256 maxPriceDeviation;
    }

    Limits public limits;
    mapping(uint256 => uint256) public dailyVolume;
    bool public tripped;

    event CircuitBreakerTripped(string reason);
    event CircuitBreakerReset();

    constructor() {
        limits = Limits({
            maxDailyVolume: 1000000e6,
            maxSingleTx: 100000e6,
            maxPriceDeviation: 1000
        });
    }

    function checkTransaction(uint256 amount) external {
        require(!tripped, "Circuit breaker tripped");

        if (amount > limits.maxSingleTx) {
            _trip("Single tx limit exceeded");
        }

        uint256 today = block.timestamp / 1 days;
        dailyVolume[today] += amount;

        if (dailyVolume[today] > limits.maxDailyVolume) {
            _trip("Daily volume limit exceeded");
        }
    }

    function _trip(string memory reason) internal {
        tripped = true;
        emit CircuitBreakerTripped(reason);
    }

    function reset() external {
        tripped = false;
        emit CircuitBreakerReset();
    }
}

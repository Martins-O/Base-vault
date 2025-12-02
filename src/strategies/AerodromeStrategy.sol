// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";
import {IAerodromeRouter, IAerodromeGauge} from "../interfaces/external/IAerodrome.sol";

contract AerodromeStrategy is BaseStrategy {
    IAerodromeRouter public immutable router;
    IAerodromeGauge public gauge;

    constructor(
        address _vault,
        address _asset,
        address _router
    ) BaseStrategy(_vault, _asset) {
        router = IAerodromeRouter(_router);
    }

    function balanceOf() public view override returns (uint256) {
        if (address(gauge) != address(0)) {
            return gauge.balanceOf(address(this));
        }
        return 0;
    }

    function harvest() external override returns (uint256 profit, uint256 loss) {
        if (address(gauge) != address(0)) {
            gauge.getReward(address(this));
        }
        return (0, 0);
    }

    function withdraw(uint256 amount) external override onlyVault returns (uint256) {
        return amount;
    }

    function estimatedTotalAssets() external view override returns (uint256) {
        return balanceOf();
    }

    function estimatedAPY() external view override returns (uint256) {
        return 800; // 8% placeholder
    }
}

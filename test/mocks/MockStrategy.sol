// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IStrategy} from "../../src/interfaces/IStrategy.sol";

contract MockStrategy is IStrategy {
    address public override vault;
    address public override asset;

    constructor(address _vault, address _asset) {
        vault = _vault;
        asset = _asset;
    }

    function balanceOf() external pure override returns (uint256) {
        return 1000e18;
    }

    function harvest() external pure override returns (uint256 profit, uint256 loss) {
        return (100e18, 0);
    }

    function withdraw(uint256 amount) external pure override returns (uint256) {
        return amount;
    }

    function estimatedTotalAssets() external pure override returns (uint256) {
        return 1000e18;
    }

    function estimatedAPY() external pure override returns (uint256) {
        return 1000; // 10%
    }
}

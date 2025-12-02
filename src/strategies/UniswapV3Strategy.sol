// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";
import {ISwapRouter} from "../interfaces/external/IUniswapV3.sol";

contract UniswapV3Strategy is BaseStrategy {
    ISwapRouter public immutable swapRouter;

    constructor(
        address _vault,
        address _asset,
        address _swapRouter
    ) BaseStrategy(_vault, _asset) {
        swapRouter = ISwapRouter(_swapRouter);
    }

    function balanceOf() public view override returns (uint256) {
        return 0; // Placeholder
    }

    function harvest() external override returns (uint256 profit, uint256 loss) {
        return (0, 0); // Placeholder
    }

    function withdraw(uint256 amount) external override onlyVault returns (uint256) {
        return amount; // Placeholder
    }

    function estimatedTotalAssets() external view override returns (uint256) {
        return balanceOf();
    }

    function estimatedAPY() external view override returns (uint256) {
        return 500; // 5% placeholder
    }
}

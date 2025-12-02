// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IStrategy} from "../interfaces/IStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract BaseStrategy is IStrategy {
    using SafeERC20 for IERC20;

    address public immutable override vault;
    address public immutable override asset;

    constructor(address _vault, address _asset) {
        vault = _vault;
        asset = _asset;
    }

    modifier onlyVault() {
        if (msg.sender != vault) revert InvalidVault();
        _;
    }

    function balanceOf() public view virtual override returns (uint256);
    function harvest() external virtual override returns (uint256 profit, uint256 loss);
    function withdraw(uint256 amount) external virtual override onlyVault returns (uint256);
    function estimatedTotalAssets() external view virtual override returns (uint256);
    function estimatedAPY() external view virtual override returns (uint256);
}

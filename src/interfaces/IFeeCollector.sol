// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFeeCollector {
    function collectFee(address token, uint256 amount) external;
    function withdrawFees(address token, uint256 amount) external;
    function getTotalFees(address token) external view returns (uint256);
}

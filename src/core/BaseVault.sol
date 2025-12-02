// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title BaseVault
 * @notice Main vault contract implementing ERC4626 standard
 * @dev Manages deposits, withdrawals, and yield strategies
 */
contract BaseVault is ERC4626 {
    using SafeERC20 for IERC20;

    // State variables
    address public governance;
    address public pendingGovernance;

    // Events
    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);

    // Errors
    error Unauthorized();
    error ZeroAddress();

    // Modifiers
    modifier onlyGovernance() {
        if (msg.sender != governance) revert Unauthorized();
        _;
    }

    /**
     * @notice Constructor
     * @param _asset The underlying asset (e.g., USDC, WETH)
     * @param _name Vault token name
     * @param _symbol Vault token symbol
     */
    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC4626(_asset) ERC20(_name, _symbol) {
        if (address(_asset) == address(0)) revert ZeroAddress();
        governance = msg.sender;
        emit GovernanceTransferred(address(0), msg.sender);
    }

    /**
     * @notice Transfer governance to a new address
     * @param _newGovernance New governance address
     */
    function transferGovernance(address _newGovernance) external onlyGovernance {
        if (_newGovernance == address(0)) revert ZeroAddress();
        pendingGovernance = _newGovernance;
    }

    /**
     * @notice Accept governance transfer
     */
    function acceptGovernance() external {
        if (msg.sender != pendingGovernance) revert Unauthorized();
        emit GovernanceTransferred(governance, pendingGovernance);
        governance = pendingGovernance;
        pendingGovernance = address(0);
    }

    /**
     * @notice Calculate total assets held by vault
     * @return Total assets in underlying token
     */
    function totalAssets() public view virtual override returns (uint256) {
        // For now, just return the balance of the vault
        // Will be extended to include strategy assets
        return IERC20(asset()).balanceOf(address(this));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IStrategy} from "../interfaces/IStrategy.sol";

/**
 * @title BaseVault
 * @notice Main vault contract implementing ERC4626 standard
 * @dev Manages deposits, withdrawals, and yield strategies
 */
contract BaseVault is ERC4626, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // State variables
    address public governance;
    address public pendingGovernance;

    // Strategy management
    address[] public strategies;
    mapping(address => bool) public isStrategy;
    mapping(address => uint256) public strategyWeights; // In basis points (10000 = 100%)

    // Constants
    uint256 public constant MAX_BPS = 10_000;
    uint256 public constant MAX_STRATEGIES = 20;

    // Events
    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);
    event StrategyAdded(address indexed strategy, uint256 weight);
    event StrategyRemoved(address indexed strategy);
    event StrategyWeightUpdated(address indexed strategy, uint256 oldWeight, uint256 newWeight);

    // Errors
    error Unauthorized();
    error ZeroAddress();
    error StrategyAlreadyExists();
    error StrategyNotFound();
    error InvalidWeight();
    error TooManyStrategies();

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
     * @notice Add a new strategy to the vault
     * @param _strategy Strategy contract address
     * @param _weight Weight in basis points
     */
    function addStrategy(address _strategy, uint256 _weight) external onlyGovernance {
        if (_strategy == address(0)) revert ZeroAddress();
        if (isStrategy[_strategy]) revert StrategyAlreadyExists();
        if (strategies.length >= MAX_STRATEGIES) revert TooManyStrategies();
        if (_weight > MAX_BPS) revert InvalidWeight();

        strategies.push(_strategy);
        isStrategy[_strategy] = true;
        strategyWeights[_strategy] = _weight;

        emit StrategyAdded(_strategy, _weight);
    }

    /**
     * @notice Remove a strategy from the vault
     * @param _strategy Strategy contract address
     */
    function removeStrategy(address _strategy) external onlyGovernance {
        if (!isStrategy[_strategy]) revert StrategyNotFound();

        // Remove from array
        for (uint256 i = 0; i < strategies.length; i++) {
            if (strategies[i] == _strategy) {
                strategies[i] = strategies[strategies.length - 1];
                strategies.pop();
                break;
            }
        }

        isStrategy[_strategy] = false;
        delete strategyWeights[_strategy];

        emit StrategyRemoved(_strategy);
    }

    /**
     * @notice Update strategy weight
     * @param _strategy Strategy contract address
     * @param _newWeight New weight in basis points
     */
    function updateStrategyWeight(address _strategy, uint256 _newWeight) external onlyGovernance {
        if (!isStrategy[_strategy]) revert StrategyNotFound();
        if (_newWeight > MAX_BPS) revert InvalidWeight();

        uint256 oldWeight = strategyWeights[_strategy];
        strategyWeights[_strategy] = _newWeight;

        emit StrategyWeightUpdated(_strategy, oldWeight, _newWeight);
    }

    /**
     * @notice Get all strategies
     * @return Array of strategy addresses
     */
    function getStrategies() external view returns (address[] memory) {
        return strategies;
    }

    /**
     * @notice Calculate total assets held by vault
     * @return Total assets in underlying token
     */
    function totalAssets() public view virtual override returns (uint256) {
        uint256 total = IERC20(asset()).balanceOf(address(this));

        // Add assets from all strategies
        for (uint256 i = 0; i < strategies.length; i++) {
            total += IStrategy(strategies[i]).estimatedTotalAssets();
        }

        return total;
    }
}

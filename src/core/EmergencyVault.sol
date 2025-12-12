// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title EmergencyVault
 * @notice Vault with emergency pause and withdrawal features
 */
contract EmergencyVault is BaseVault {
    using SafeERC20 for IERC20;

    bool public emergencyMode;
    mapping(address => bool) public guardians;
    uint256 public emergencyWithdrawalWindow = 7 days;
    uint256 public emergencyActivatedAt;

    event EmergencyActivated(address indexed guardian, string reason);
    event EmergencyDeactivated(address indexed guardian);
    event GuardianAdded(address indexed guardian);
    event GuardianRemoved(address indexed guardian);
    event EmergencyWithdrawal(address indexed user, uint256 amount);

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Not a guardian");
        _;
    }

    modifier whenNotEmergency() {
        require(!emergencyMode, "Emergency mode active");
        _;
    }

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol
    ) BaseVault(_asset, _name, _symbol) {
        guardians[msg.sender] = true;
    }

    function addGuardian(address guardian) external onlyGovernance {
        require(guardian != address(0), "Invalid guardian");
        guardians[guardian] = true;
        emit GuardianAdded(guardian);
    }

    function removeGuardian(address guardian) external onlyGovernance {
        guardians[guardian] = false;
        emit GuardianRemoved(guardian);
    }

    function activateEmergency(string calldata reason) external onlyGuardian {
        emergencyMode = true;
        emergencyActivatedAt = block.timestamp;
        emit EmergencyActivated(msg.sender, reason);
    }

    function deactivateEmergency() external onlyGuardian {
        require(emergencyMode, "Not in emergency");
        emergencyMode = false;
        emit EmergencyDeactivated(msg.sender);
    }

    function emergencyWithdraw() external {
        require(emergencyMode, "Not in emergency mode");
        require(
            block.timestamp <= emergencyActivatedAt + emergencyWithdrawalWindow,
            "Emergency window closed"
        );

        uint256 shares = balanceOf(msg.sender);
        require(shares > 0, "No shares");

        uint256 assets = convertToAssets(shares);

        _burn(msg.sender, shares);
        IERC20(asset()).safeTransfer(msg.sender, assets);

        emit EmergencyWithdrawal(msg.sender, assets);
    }

    function deposit(uint256 assets, address receiver)
        public
        virtual
        override
        whenNotEmergency
        returns (uint256)
    {
        return super.deposit(assets, receiver);
    }

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public virtual override whenNotEmergency returns (uint256) {
        return super.withdraw(assets, receiver, owner);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {Whitelist} from "../access/Whitelist.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title PermissionedVault
 * @notice Vault with whitelist-gated access
 */
contract PermissionedVault is BaseVault {
    Whitelist public immutable whitelist;
    bool public permissionless;

    event PermissionModeChanged(bool permissionless);

    modifier onlyWhitelisted(address user) {
        if (!permissionless) {
            require(
                whitelist.checkWhitelist(address(this), user),
                "Not whitelisted"
            );
        }
        _;
    }

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        address _whitelist
    ) BaseVault(_asset, _name, _symbol) {
        whitelist = Whitelist(_whitelist);
        permissionless = false;
    }

    function setPermissionless(bool _permissionless) external onlyGovernance {
        permissionless = _permissionless;
        emit PermissionModeChanged(_permissionless);
    }

    function deposit(uint256 assets, address receiver)
        public
        virtual
        override
        onlyWhitelisted(receiver)
        returns (uint256)
    {
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver)
        public
        virtual
        override
        onlyWhitelisted(receiver)
        returns (uint256)
    {
        return super.mint(shares, receiver);
    }

    function isUserWhitelisted(address user) external view returns (bool) {
        return permissionless || whitelist.checkWhitelist(address(this), user);
    }
}

# BaseVault API Documentation

## Core Vault Functions

### deposit(uint256 assets, address receiver)
Deposit assets into the vault.

**Parameters:**
- `assets`: Amount of assets to deposit
- `receiver`: Address to receive vault shares

**Returns:** `shares` - Number of shares minted

### withdraw(uint256 assets, address receiver, address owner)
Withdraw assets from the vault.

**Parameters:**
- `assets`: Amount of assets to withdraw
- `receiver`: Address to receive assets
- `owner`: Owner of the shares

**Returns:** `shares` - Number of shares burned

## Fee Functions

### collectFee(address token, uint256 amount)
Collect fees to fee collector.

### getFeeStructure()
Returns current fee configuration.

## View Functions

### totalAssets()
Returns total assets under management.

### convertToShares(uint256 assets)
Preview shares for asset amount.

### convertToAssets(uint256 shares)
Preview assets for share amount.

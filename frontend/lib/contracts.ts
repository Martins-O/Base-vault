// Contract addresses on Base Sepolia
export const CONTRACTS = {
  FEE_COLLECTOR: '0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce' as `0x${string}`,
  INTERACTIVE_VAULT: '0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC' as `0x${string}`,
  VAULT_FACTORY: '0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8' as `0x${string}`,
  AERODROME_STRATEGY: '0xD248B35E5D2CBC4562D025daa1d0850A529E360b' as `0x${string}`,
  UNISWAP_V3_STRATEGY: '0x9923Ec8b23D8f5442d641Cd9bd5918d56E8fA031' as `0x${string}`,
  USDC: '0x036CbD53842c5426634e7929541eC2318f3dCF7e' as `0x${string}`,
} as const;

// InteractiveVault ABI (simplified for frontend use)
export const INTERACTIVE_VAULT_ABI = [
  {
    "inputs": [
      { "internalType": "uint256", "name": "assets", "type": "uint256" },
      { "internalType": "address", "name": "receiver", "type": "address" }
    ],
    "name": "deposit",
    "outputs": [{ "internalType": "uint256", "name": "shares", "type": "uint256" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "assets", "type": "uint256" },
      { "internalType": "address", "name": "receiver", "type": "address" },
      { "internalType": "address", "name": "owner", "type": "address" }
    ],
    "name": "withdraw",
    "outputs": [{ "internalType": "uint256", "name": "shares", "type": "uint256" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalAssets",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "address", "name": "user", "type": "address" }],
    "name": "userInfo",
    "outputs": [
      { "internalType": "uint256", "name": "totalDeposited", "type": "uint256" },
      { "internalType": "uint256", "name": "totalWithdrawn", "type": "uint256" },
      { "internalType": "uint256", "name": "feesPaid", "type": "uint256" },
      { "internalType": "uint256", "name": "lastAction", "type": "uint256" }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalUsers",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "address", "name": "account", "type": "address" }],
    "name": "balanceOf",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  }
] as const;

// ERC20 ABI for USDC
export const ERC20_ABI = [
  {
    "inputs": [
      { "internalType": "address", "name": "spender", "type": "address" },
      { "internalType": "uint256", "name": "amount", "type": "uint256" }
    ],
    "name": "approve",
    "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{ "internalType": "address", "name": "account", "type": "address" }],
    "name": "balanceOf",
    "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "decimals",
    "outputs": [{ "internalType": "uint8", "name": "", "type": "uint8" }],
    "stateMutability": "view",
    "type": "function"
  }
] as const;

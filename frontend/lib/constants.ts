export const FEE_BPS = {
  DEPOSIT: 50, // 0.5%
  WITHDRAWAL: 30, // 0.3%
  PERFORMANCE: 1000, // 10%
  MAX_BPS: 10000,
} as const;

export const NETWORK = {
  chainId: 84532,
  name: 'Base Sepolia',
  rpcUrl: 'https://sepolia.base.org',
  blockExplorer: 'https://sepolia.basescan.org',
} as const;

export const STRATEGIES = {
  AERODROME: 'Aerodrome LP',
  UNISWAP_V3: 'Uniswap V3',
  MULTI: 'Multi-Strategy',
} as const;

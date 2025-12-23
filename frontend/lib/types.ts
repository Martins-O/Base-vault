export interface Vault {
  address: string;
  name: string;
  tvl: number;
  apy: number;
  strategy: string;
  totalUsers: number;
}

export interface UserPosition {
  totalDeposited: number;
  totalWithdrawn: number;
  feesPaid: number;
  shareBalance: number;
  usdcBalance: number;
}

export interface Transaction {
  hash: string;
  type: 'deposit' | 'withdraw';
  amount: string;
  timestamp: string;
  status: 'success' | 'pending' | 'failed';
}

export interface FeeStats {
  totalFeesCollected: number;
  depositFees: number;
  withdrawalFees: number;
  performanceFees: number;
}

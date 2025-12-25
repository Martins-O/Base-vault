export async function fetchVaultData(vaultAddress: string) {
  // Mock API call - replace with actual API
  return {
    tvl: 25432,
    apy: 12.5,
    totalUsers: 150,
  };
}

export async function fetchTransactions(userAddress: string) {
  // Mock API call
  return [];
}

export async function fetchFeeStats() {
  return {
    totalFeesCollected: 1234.56,
    depositFees: 456.78,
    withdrawalFees: 234.12,
    performanceFees: 543.66,
  };
}

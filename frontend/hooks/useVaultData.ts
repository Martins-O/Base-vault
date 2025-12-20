'use client';

import { useReadContract } from 'wagmi';
import { CONTRACTS, INTERACTIVE_VAULT_ABI } from '@/lib/contracts';

export function useVaultData() {
  const { data: totalAssets, isLoading: isLoadingAssets } = useReadContract({
    address: CONTRACTS.INTERACTIVE_VAULT,
    abi: INTERACTIVE_VAULT_ABI,
    functionName: 'totalAssets',
  });

  const { data: totalUsers, isLoading: isLoadingUsers } = useReadContract({
    address: CONTRACTS.INTERACTIVE_VAULT,
    abi: INTERACTIVE_VAULT_ABI,
    functionName: 'totalUsers',
  });

  return {
    totalAssets: totalAssets ? Number(totalAssets) / 1e6 : 0, // Convert from 6 decimals
    totalUsers: totalUsers ? Number(totalUsers) : 0,
    isLoading: isLoadingAssets || isLoadingUsers,
  };
}

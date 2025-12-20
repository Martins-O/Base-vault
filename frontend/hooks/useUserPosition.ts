'use client';

import { useAccount, useReadContract } from 'wagmi';
import { CONTRACTS, INTERACTIVE_VAULT_ABI, ERC20_ABI } from '@/lib/contracts';

export function useUserPosition() {
  const { address } = useAccount();

  const { data: userInfo } = useReadContract({
    address: CONTRACTS.INTERACTIVE_VAULT,
    abi: INTERACTIVE_VAULT_ABI,
    functionName: 'userInfo',
    args: address ? [address] : undefined,
  });

  const { data: shareBalance } = useReadContract({
    address: CONTRACTS.INTERACTIVE_VAULT,
    abi: INTERACTIVE_VAULT_ABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
  });

  const { data: usdcBalance } = useReadContract({
    address: CONTRACTS.USDC,
    abi: ERC20_ABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
  });

  if (!userInfo || !address) {
    return {
      totalDeposited: 0,
      totalWithdrawn: 0,
      feesPaid: 0,
      shareBalance: 0,
      usdcBalance: 0,
    };
  }

  return {
    totalDeposited: Number(userInfo[0]) / 1e6,
    totalWithdrawn: Number(userInfo[1]) / 1e6,
    feesPaid: Number(userInfo[2]) / 1e6,
    shareBalance: shareBalance ? Number(shareBalance) / 1e18 : 0,
    usdcBalance: usdcBalance ? Number(usdcBalance) / 1e6 : 0,
  };
}

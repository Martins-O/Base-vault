'use client';

import { useAccount, useChainId } from 'wagmi';
import { baseSepolia } from 'wagmi/chains';

export function NetworkStatus() {
  const { isConnected } = useAccount();
  const chainId = useChainId();

  if (!isConnected) return null;

  const isCorrectNetwork = chainId === baseSepolia.id;

  return (
    <div className={`px-3 py-1 rounded-full text-sm ${
      isCorrectNetwork
        ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
        : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
    }`}>
      {isCorrectNetwork ? 'Base Sepolia' : 'Wrong Network'}
    </div>
  );
}

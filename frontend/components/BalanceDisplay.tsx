'use client';

import { useAccount, useBalance } from 'wagmi';

export function BalanceDisplay() {
  const { address } = useAccount();
  const { data: balance } = useBalance({ address });

  if (!address || !balance) return null;

  return (
    <div className="text-sm text-gray-600 dark:text-gray-400">
      {parseFloat(balance.formatted).toFixed(4)} {balance.symbol}
    </div>
  );
}

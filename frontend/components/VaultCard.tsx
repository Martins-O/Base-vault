'use client';

import Link from 'next/link';

interface VaultCardProps {
  name: string;
  address: string;
  tvl: string;
  apy: string;
  strategy: string;
}

export function VaultCard({ name, address, tvl, apy, strategy }: VaultCardProps) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
      <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
        {name}
      </h3>
      <p className="text-sm text-gray-500 dark:text-gray-400 mb-4 font-mono">
        {address.slice(0, 6)}...{address.slice(-4)}
      </p>

      <div className="space-y-2 mb-4">
        <div className="flex justify-between">
          <span className="text-gray-600 dark:text-gray-400">TVL:</span>
          <span className="font-semibold text-gray-900 dark:text-white">{tvl}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-600 dark:text-gray-400">APY:</span>
          <span className="font-semibold text-green-600 dark:text-green-400">{apy}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-gray-600 dark:text-gray-400">Strategy:</span>
          <span className="text-sm text-gray-700 dark:text-gray-300">{strategy}</span>
        </div>
      </div>

      <Link
        href={`/vaults/${address}`}
        className="block w-full text-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md transition-colors"
      >
        Manage Vault
      </Link>
    </div>
  );
}

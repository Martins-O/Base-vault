'use client';

interface VaultMetricsProps {
  tvl: number;
  apy: number;
  totalUsers: number;
}

export function VaultMetrics({ tvl, apy, totalUsers }: VaultMetricsProps) {
  return (
    <div className="grid grid-cols-3 gap-4">
      <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
        <p className="text-sm text-gray-600 dark:text-gray-400">TVL</p>
        <p className="text-xl font-bold text-gray-900 dark:text-white">
          ${tvl.toLocaleString()}
        </p>
      </div>
      <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
        <p className="text-sm text-gray-600 dark:text-gray-400">APY</p>
        <p className="text-xl font-bold text-green-600 dark:text-green-400">
          {apy.toFixed(2)}%
        </p>
      </div>
      <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
        <p className="text-sm text-gray-600 dark:text-gray-400">Users</p>
        <p className="text-xl font-bold text-gray-900 dark:text-white">
          {totalUsers}
        </p>
      </div>
    </div>
  );
}
